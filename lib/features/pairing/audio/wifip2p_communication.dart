/// {@category GroupPairing}
library;
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:messagepack/messagepack.dart';
import 'package:pairsonic/helper_functions.dart';
import 'package:pairsonic/service_locator.dart';
import 'package:typed_data/typed_data.dart';

import 'grouppairing_helper.dart';
import 'interfaces/grouppairing_communication_interface.dart';
import 'models/grouppairing_models.dart';
import 'services/wifi_p2p_service.dart';

/// Implementation of [GroupPairingCommunicationInterface] using
/// [StorageService] to communicate with the central server.
/// The central server stores the group pairing data based on
/// a [_sessionId].
class GPWifiP2pCommunication implements GroupPairingCommunicationInterface {
  /// The port used by the coordinator to listen for incoming connections.
  static const int socketPort = 15199;

  static final _wifiService = getIt<WifiP2pService>();
  final int _participantCount;

  /// The group information of the currently active Wi-Fi P2P group.
  WifiP2pGroupInfo? _groupInfo;

  /// The connection information of the currently active Wi-Fi connection.
  WifiP2pConnectionInfo? _connectionInfo;

  /// The socket the server/coordinator listens on.
  ServerSocket? _serverSocket;

  /// All active connections on this device.
  /// For non-coordinators, this contains just the connection to the coordinator.
  /// For the coordinator, this contains connections to all other participants.
  final Map<Socket, _ProtocolConnection> _connections = {};

  /// Whether this instance belongs to a coordinator or not.
  final bool _isClient;

  /// The received main commitments.
  final List<GPMainCommitment> _mainCommitments = [];

  /// The received main reveals.
  final List<GPMainReveal> _mainReveals = [];

  /// The receied match reveals.
  final List<GPMatchWrongReveal> _matchReveals = [];

  /// The received wrong reveals.
  final List<GPMatchWrongReveal> _wrongReveals = [];

  final Queue<GPSecretSharingPacket> _receivedEncryptionSecret = Queue();

  GPWifiP2pCommunication(this._participantCount, this._isClient);

  @override
  int get connectionCount => _connections.length;

  @override
  int get participantCount => _participantCount;

  @override
  Future<void> dispose() async {
    await Future.forEach(_connections.keys, (Socket element) async {
      element.close();
    });
    if (_serverSocket != null) {
      await _serverSocket!.close();
    }
    if (!_isClient) {
      await _wifiService.removeGroup();
    } else {
      await _wifiService.disconnect();
    }
  }

  /// Tries to create a socket connected to the [connectionInfo] address and port.
  /// If the creation fails, it is retried for [attempts] times, each with a delay
  /// of [delayMs] milliseconds.
  ///
  /// This function was necessary, since very slow devices (like LG Nexus 5)
  /// did not connect to the WiFi network in time before the socket was
  /// created, leading to an exception.
  Future<Socket?> _createSocket({required int attempts, int delayMs = 500}) async {
    try {
      return await Socket.connect(_connectionInfo!.ownerAddress, socketPort);
    } catch (e) {
      await Future.delayed(Duration(milliseconds: delayMs));
      if (attempts > 0) {
        return await _createSocket(attempts: attempts - 1, delayMs: delayMs);
      } else {
        return null;
      }
    }
  }

  @override
  Future<bool> establishConnection() async {
    if (_isClient) {
      // In case this is a client, we need to connect to the coordinator.
      // In [fromInitData], we have already send a connection request to the
      // Wi-Fi connection framework. Now, we need to wait until the Wi-Fi
      // is established and we have an IP.
      if (_groupInfo == null &&
          _connectionInfo == null &&
          await _wifiService.requestGroupInfo() != null &&
          await _wifiService.requestConnectionInfo() != null) {
        // Connection is established and we have an IP.
        _groupInfo = _wifiService.groupInfo;
        _connectionInfo = _wifiService.connectionInfo;

        // Connect to the server TCP socket.
        final clientSocket = await _createSocket(attempts: 10);
        if (clientSocket == null) {
          throw Exception("Could not connect to coordinator in time. Try to turn WiFi off and on again.");
        }
        debugPrint(
            "GPWifiP2pCommunication - _joinGroup: Connected to server ($_connectionInfo)");
        _connections[clientSocket] = _ProtocolConnection(clientSocket, this);
        clientSocket.listen((data) => _processMessage(clientSocket, data),
            onError: (error) {
          debugPrint("GPWifiP2pCommunication: Error: $error");
          clientSocket.close();
          _connections.remove(clientSocket);
        }, onDone: () {
          debugPrint("GPWifiP2pCommunication: Disconnected from server");
          clientSocket.close();
          _connections.remove(clientSocket);
        });
        return false;
      } else if (_connections.isNotEmpty &&
          _connections.values.first.receivedReady) {
        // Even if we are connected, we need to wait until the server has
        // sent us the ready message.
        // When we haved received this message, the connection is established.
        return true;
      } else {
        return false;
      }
    } else {
      // In case this is a coordinator, we need to wait until all participants
      // have connected to our TCP server socket.
      if (_connections.length >= participantCount - 1) {
        // All participants have connected.
        // Send them the ready message.
        _connections.forEach((key, value) {
          value.sendReadyMessage();
        });
        return true;
      }
      return false;
    }
  }

  @override
  Uint8List getInitData() {
    final bytesBuilder = BytesBuilder();
    bytesBuilder.addByte(1);
    final p = Packer();
    p.packInt(_participantCount);
    p.packString(_groupInfo!.ssid);
    p.packString(_groupInfo!.passphrase);
    print("ssid: ${_groupInfo!.ssid} -- passphrase: ${_groupInfo!.passphrase}");
    bytesBuilder.add(p.takeBytes());
    return bytesBuilder.toBytes();
  }

  @override
  Future<int> getUid() async {
    // return a random integer between 0 and 2^32-1
    // the probability of a collision is very small
    var rng = Random.secure();
    return rng.nextInt(0x7fffffff);
  }

  @override
  Future<List<GPMainCommitment>> pollMainCommitments() async {
    return _mainCommitments;
  }

  @override
  Future<List<GPMainReveal>> pollMainReveals() async {
    return _mainReveals;
  }

  @override
  Future<List<GPMatchWrongReveal>> pollMatchReveals() async {
    return _matchReveals;
  }

  @override
  Future<List<GPMatchWrongReveal>> pollWrongReveals() async {
    return _wrongReveals;
  }

  @override
  Future<GPSecretSharingPacket?> pollSecret() async {
    return _receivedEncryptionSecret.isNotEmpty
        ? _receivedEncryptionSecret.removeFirst()
        : null;
  }

  @override
  Future<void> sendMainCommitment(GPMainCommitment commitment) async {
    _connections.forEach((key, value) {
      value.sendMainCommitment(commitment);
    });
  }

  @override
  Future<void> sendMainReveal(GPMainReveal reveal) async {
    _connections.forEach((key, value) {
      value.sendMainReveal(reveal);
    });
  }

  @override
  Future<void> sendMatchReveal(GPMatchWrongReveal reveal) async {
    assert(reveal.isMatch);
    _connections.forEach((key, value) {
      value.sendMatchWrongReveal(reveal);
    });
  }

  @override
  Future<void> sendWrongReveal(GPMatchWrongReveal reveal) async {
    assert(!reveal.isMatch);
    _connections.forEach((key, value) {
      value.sendMatchWrongReveal(reveal);
    });
  }

  @override
  Future<void> sendSecret(GPSecretSharingPacket encryptedSecret) async {
    _connections.forEach((key, value) {
      value.sendSecret(encryptedSecret);
    });
  }

  Future<void> _asyncInit() async {
    await _wifiService.init();
    if (!await _wifiService.waitForAvailable()) {
      debugPrint("GPWifiP2pCommunication: No Wifi P2P available");
      throw WifiP2pUnavailableException();
    }
  }

  /// Function called on the coordinators side to create a Wi-Fi P2P group.
  /// This function will return when the group is created.
  Future<void> _createGroup() async {
    assert(_wifiService.available);
    assert(_groupInfo == null);
    bool result = await _wifiService.createGroup();
    if (result == false) {
      throw WifiP2pGroupCreationFailed();
    }
    // Wait until the group is created and we have its information.
    _groupInfo = await _wifiService.waitForGroupInfo();
    if (_groupInfo == null) {
      throw WifiP2pGroupCreationFailed();
    }
    // Create a TCP server socket that accepts all incoming connections and
    // adds them to [connections].
    _serverSocket =
        await ServerSocket.bind(InternetAddress.anyIPv4, socketPort);
    debugPrint("GPWifiP2pCommunication - _createGroup: Server is bound");
    _serverSocket!.listen((client) {
      debugPrint(
          "GPWifiP2pCommunication: Client connected (${client.remoteAddress.toString()})");
      _connections[client] = _ProtocolConnection(client, this);

      client.listen((data) => _processMessage(client, data), onError: (error) {
        debugPrint("GPWifiP2pCommunication: Error: $error");
        client.close();
        _connections.remove(client);
      }, onDone: () {
        debugPrint("GPWifiP2pCommunication: Client disconnected");
        client.close();
        _connections.remove(client);
      });
    });
  }

  /// Function called on the participants side to join an existing
  /// Wi-Fi P2P group. This function will return once the request
  /// for joining has been sent to the operating system.
  ///
  /// This does not mean the connection has been established.
  Future<void> _joinGroup(WifiP2pGroupInfo groupInfo) async {
    assert(_wifiService.available);
    assert(_groupInfo == null);
    bool result = await _wifiService.connect(groupInfo);
    if (result == false) {
      throw WifiP2pGroupJoiningFailed();
    }
  }

  /// Function called everytime data is on any connection.
  Future<void> _processMessage(Socket client, Uint8List data) async {
    _ProtocolConnection connection = _connections[client]!;
    connection.addData(data);
    connection.processData();
  }

  /// Creates a new [GPWifiP2pCommunication] object for a
  /// given [participantCount] and initializes the [_sessionId] with random
  /// bytes.
  static Future<GPWifiP2pCommunication> create(int participantCount) async {
    var res = GPWifiP2pCommunication(participantCount, false);
    await res._asyncInit();
    await res._createGroup();
    return res;
  }

  /// Creates a new [GPWifiP2pCommunication] from given [initData].
  static Future<GPWifiP2pCommunication> fromInitData(Uint8List initData) async {
    assert(initData[0] == 1);
    final msgpack = Uint8List.sublistView(initData, 1, initData.length);
    final u = Unpacker.fromList(msgpack);
    final participantCount = u.unpackInt();
    final ssid = u.unpackString();
    final passphrase = u.unpackString();

    var res = GPWifiP2pCommunication(participantCount!, true);
    var groupInfo = WifiP2pGroupInfo(ssid: ssid!, passphrase: passphrase!);
    await res._asyncInit();
    await res._joinGroup(groupInfo);

    return res;
  }
}

class ProtocolException implements Exception {
  final String message;
  ProtocolException(this.message);
}

class WifiP2pException implements Exception {}

class WifiP2pGroupCreationFailed implements WifiP2pException {
  WifiP2pGroupCreationFailed();

  @override
  String toString() {
    return "Unable to create Wi-Fi P2P group";
  }
}

class WifiP2pGroupJoiningFailed implements WifiP2pException {
  WifiP2pGroupJoiningFailed();

  @override
  String toString() {
    return "Unable to join Wi-Fi P2P group";
  }
}

class WifiP2pUnavailableException implements WifiP2pException {
  WifiP2pUnavailableException();

  @override
  String toString() {
    return "WiFi P2P is currently unavailable";
  }
}

class _ProtocolConnection {
  final Socket _sock;
  final GPWifiP2pCommunication _comm;
  bool _receivedReady = false;

  final Uint8Buffer _buffer = Uint8Buffer(0);

  int _expectedBytes = 5;

  _ProtocolMessageParserState _state =
      _ProtocolMessageParserState.waitingForMessageType;
  _ProtocolConnection(this._sock, this._comm);
  bool get receivedReady => _receivedReady;

  /// Add [data] to the internal buffer.
  void addData(Uint8List data) {
    _buffer.addAll(data);
  }

  /// Process the internal buffer.
  void processData() {
    // reprocess is used to immediately consume more data if the current
    // buffer still has enough content. This is used to avoid having to
    // wait for the next call to [processData] to consume more data.
    bool reprocess = true;
    do {
      reprocess = _processData();
    } while (reprocess);
    return;
  }

  void sendMainCommitment(GPMainCommitment mainCommitment) {
    debugPrint(
        "_ProtocolConnection - sendMainCommitment: Sending to ${_sock.remoteAddress.toString()} - ${mainCommitment.uid}");
    BytesBuilder bb = BytesBuilder();
    bb.addByte(_ProtocolMessageType.mainCommitment.index);
    Packer p = Packer();

    p.packInt(mainCommitment.uid);
    p.packBinary(mainCommitment.commitment);
    Uint8List data = p.takeBytes();

    bb.add(intToBytes(data.length));
    bb.add(data);

    _sock.add(bb.takeBytes());
  }

  void sendMainReveal(GPMainReveal mainReveal) {
    debugPrint(
        "_ProtocolConnection - sendMainReveal: Sending to ${_sock.remoteAddress.toString()} - ${mainReveal.uid}");
    BytesBuilder bb = BytesBuilder();
    bb.addByte(_ProtocolMessageType.mainReveal.index);
    Packer p = Packer();

    p.packInt(mainReveal.uid);
    p.packBinary(mainReveal.hashN);
    p.packBinary(mainReveal.dhPublicKey);
    p.packBinary(mainReveal.encryptedUserData);
    Uint8List data = p.takeBytes();

    bb.add(intToBytes(data.length));
    bb.add(data);

    _sock.add(bb.takeBytes());
  }

  void sendMatchWrongReveal(GPMatchWrongReveal matchWrongReveal) {
    debugPrint(
        "_ProtocolConnection - sendMatchWrongReveal: Sending to ${_sock.remoteAddress.toString()} - ${matchWrongReveal.uid}");
    BytesBuilder bb = BytesBuilder();
    bb.addByte(_ProtocolMessageType.matchWrongReveal.index);
    Packer p = Packer();

    p.packInt(matchWrongReveal.uid);
    p.packBinary(matchWrongReveal.nonce);
    p.packBinary(matchWrongReveal.hash);
    p.packBool(matchWrongReveal.isMatch);
    Uint8List data = p.takeBytes();

    bb.add(intToBytes(data.length));
    bb.add(data);

    _sock.add(bb.takeBytes());
  }

  void sendSecret(GPSecretSharingPacket secret) {
    Packer packer = Packer();
    packer.packInt(secret.dhUid);
    packer.packBinary(secret.dhPublicKey);
    packer.packInt(secret.secretUid);
    packer.packBinary(secret.encryptedSecret);

    Uint8List data = packer.takeBytes();
    BytesBuilder bb = BytesBuilder();

    bb.addByte(_ProtocolMessageType.encryptionSecret.index); // type
    bb.add(intToBytes(data.length));
    bb.add(data);

    _sock.add(bb.takeBytes());
  }

  void sendReadyMessage() {
    debugPrint(
        "_ProtocolConnection - sendReadyMessage: Sending to ${_sock.remoteAddress.toString()}");

    BytesBuilder bb = BytesBuilder();
    bb.addByte(_ProtocolMessageType.ready.index);
    bb.add(intToBytes(0));
    _sock.add(bb.takeBytes());
  }

  void _parseMainCommitment() {
    Uint8List data = takeN(_expectedBytes, _buffer);
    Unpacker u = Unpacker(data);
    try {
      int? uid = u.unpackInt();
      Uint8List commitment = Uint8List.fromList(u.unpackBinary());

      if (uid == null || commitment.isEmpty) {
        throw ProtocolException("Invalid message");
      }

      GPMainCommitment mainCommitment = GPMainCommitment(uid, commitment);
      debugPrint(
          "_ProtocolConnection - _parseMainCommitment: Received from ${_sock.remoteAddress.toString()} - $uid");
      _comm._mainCommitments.add(mainCommitment);
      _comm._connections.forEach((key, value) {
        if (key != _sock) {
          value.sendMainCommitment(mainCommitment);
        }
      });
    } on FormatException {
      throw ProtocolException("Invalid message format");
    }
  }

  void _parseMainReveal() {
    Uint8List data = takeN(_expectedBytes, _buffer);
    Unpacker u = Unpacker(data);
    try {
      int? uid = u.unpackInt();
      Uint8List hashN = Uint8List.fromList(u.unpackBinary());
      Uint8List dhPublicKey = Uint8List.fromList(u.unpackBinary());
      Uint8List encryptedUserData = Uint8List.fromList(u.unpackBinary());

      if (uid == null ||
          !isValidGPDigestLength(hashN.length) ||
          dhPublicKey.isEmpty ||
          encryptedUserData.isEmpty) {
        throw ProtocolException("Invalid message");
      }

      GPMainReveal mainReveal = GPMainReveal(uid, hashN, dhPublicKey, encryptedUserData);
      debugPrint(
          "_ProtocolConnection - _parseMainReveal: Received from ${_sock.remoteAddress.toString()} - $uid");
      _comm._mainReveals.add(mainReveal);
      _comm._connections.forEach((key, value) {
        if (key != _sock) {
          value.sendMainReveal(mainReveal);
        }
      });
    } on FormatException {
      throw ProtocolException("Invalid message format");
    }
  }

  void _parseMatchWrongReveal() {
    Uint8List data = takeN(_expectedBytes, _buffer);
    Unpacker u = Unpacker(data);
    try {
      int? uid = u.unpackInt();
      Uint8List nonce = Uint8List.fromList(u.unpackBinary());
      Uint8List hash = Uint8List.fromList(u.unpackBinary());
      bool? isMatch = u.unpackBool();

      if (uid == null ||
          nonce.isEmpty ||
          !isValidGPDigestLength(hash.length) ||
          isMatch == null) {
        throw ProtocolException("Invalid message");
      }

      GPMatchWrongReveal matchWrongReveal =
          GPMatchWrongReveal(uid, nonce, hash, isMatch);
      debugPrint(
          "_ProtocolConnection - _parseMatchWrongReveal: Received from ${_sock.remoteAddress.toString()} - $uid");
      if (isMatch) {
        _comm._matchReveals.add(GPMatchWrongReveal(uid, nonce, hash, isMatch));
      } else {
        _comm._wrongReveals.add(GPMatchWrongReveal(uid, nonce, hash, isMatch));
      }
      _comm._connections.forEach((key, value) {
        if (key != _sock) {
          value.sendMatchWrongReveal(matchWrongReveal);
        }
      });
    } on FormatException {
      throw ProtocolException("Invalid message format");
    }
  }

  void _parseSecretSharingPacket() {
    Uint8List data = takeN(_expectedBytes, _buffer);
    Unpacker unpacker = Unpacker(data);
    try {
      int? dhUid = unpacker.unpackInt();
      Uint8List dhPublicKey = Uint8List.fromList(unpacker.unpackBinary());
      int? secretUid = unpacker.unpackInt();
      Uint8List encryptedSecret = Uint8List.fromList(unpacker.unpackBinary());

      if (dhUid == null || dhPublicKey.isEmpty || secretUid == null || encryptedSecret.isEmpty) {
        throw ProtocolException("Invalid secret message");
      }

      final packet = GPSecretSharingPacket(dhUid, dhPublicKey, secretUid, encryptedSecret);
      _comm._receivedEncryptionSecret.addLast(packet);
    } on FormatException {
      throw ProtocolException("Invalid message format");
    }
  }

  /// The internal function that processes incoming data.
  bool _processData() {
    // Check whether enough data is in the internal buffer.
    // If not, abort (this sets reprocess to false).
    if (_buffer.length < _expectedBytes) {
      return false;
    }

    switch (_state) {
      case _ProtocolMessageParserState.waitingForMessageType:
        var messageType = _ProtocolMessageType.values[_buffer.removeAt(0)];
        _expectedBytes = takeInt(_buffer);
        if (messageType == _ProtocolMessageType.mainCommitment) {
          _state = _ProtocolMessageParserState.waitingForMainCommitment;
        } else if (messageType == _ProtocolMessageType.mainReveal) {
          _state = _ProtocolMessageParserState.waitingForMainReveal;
        } else if (messageType == _ProtocolMessageType.matchWrongReveal) {
          _state = _ProtocolMessageParserState.waitingForMatchWrongReveal;
        } else if (messageType == _ProtocolMessageType.encryptionSecret) {
          _state = _ProtocolMessageParserState.waitingForEncryptionSecret;
        } else if (messageType == _ProtocolMessageType.ready) {
          _receivedReady = true;
          _expectedBytes = 5;
          debugPrint("_ProtocolConnection: received ready");
        } else {
          throw ProtocolException("Unknown message type");
        }
        break;
      case _ProtocolMessageParserState.waitingForMainCommitment:
        _parseMainCommitment();
        _expectedBytes = 5;
        _state = _ProtocolMessageParserState.waitingForMessageType;
        break;
      case _ProtocolMessageParserState.waitingForMainReveal:
        _parseMainReveal();
        _expectedBytes = 5;
        _state = _ProtocolMessageParserState.waitingForMessageType;
        break;
      case _ProtocolMessageParserState.waitingForMatchWrongReveal:
        _parseMatchWrongReveal();
        _expectedBytes = 5;
        _state = _ProtocolMessageParserState.waitingForMessageType;
        break;
      case _ProtocolMessageParserState.waitingForEncryptionSecret:
        _parseSecretSharingPacket();
        _expectedBytes = 5;
        _state = _ProtocolMessageParserState.waitingForMessageType;
        break;
    }

    return true;
  }
}

enum _ProtocolMessageParserState {
  waitingForMessageType,
  waitingForMainCommitment,
  waitingForMainReveal,
  waitingForMatchWrongReveal,
  waitingForEncryptionSecret
}

enum _ProtocolMessageType {
  mainCommitment,
  mainReveal,
  matchWrongReveal,
  encryptionSecret,
  ready
}
