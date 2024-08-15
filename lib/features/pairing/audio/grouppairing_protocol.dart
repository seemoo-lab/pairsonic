/// Library that contains the main protocol implementation
/// for group pairing.
///
/// {@category GroupPairing}
library grouppairing_protocol;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'grouppairing_helper.dart';
import 'interfaces/audio_channel_interface.dart';
import 'interfaces/grouppairing_communication_interface.dart';
import 'interfaces/grouppairing_crypto_service_interface.dart';
import 'models/grouppairing_errors.dart';
import 'models/grouppairing_models.dart';
import 'services/grouppairing_crypto_service_aes_gcm_ecdh.dart';
import 'wifip2p_communication.dart';

part 'grouppairing_settings.dart';

/// Main class that implements all the group pairing protocol logic.
class GroupPairingProtocol<T> {
  /// The [GroupPairingCommunicationInterface] that is used for communication.
  /// Initialized in the .coordinator constructor and DEVICE_INIT2, respectively.
  late final GroupPairingCommunicationInterface _comm;

  /// The [AudioChannelService] that is used for low-bandwith, broadcast
  /// communication over an audio channel.
  final AudioChannelService<Uint8List> _audioChannel;

  /// The history of states. Does contain the current state but no duplicates.
  final List<GroupPairingState> _stateHistory = [];

  /// The list of messages transmitted over the audio channel.
  /// Used to check all received messages for possible adversaries.
  final List<Uint8List> _transmittedAudioChannelMessages = [];

  /// The current state. Don't update this manually, use [_updateState] instead.
  GroupPairingState _state = GroupPairingState.init;

  /// Whether to loop in the current [step] call and process
  /// the next state.
  bool _processNext = false;

  /// Whether the owner of the [GroupPairingProtocol] is the coordinator.
  final bool _isCoordinator;

  /// The [GroupPairingSettings] that are used for the protocol.
  final GrouppairingProtocolSettings settings;

  /// A stopwatch that is used for detecting timeouts.
  /// Is resetted as needed.
  final Stopwatch _timeoutStopwatch = Stopwatch();

  /// A stopwatch used to measure the time spent in each state.
  final Stopwatch _stateStopwatch = Stopwatch();

  late final GroupPairingCryptoServiceInterface _cryptoService = settings.cryptoServiceFactory();

  /// The [GroupPairingCommitment] used for the current protocol run.
  /// Initialized in SEND_COMMITMENT.
  late final GPCommitment _commitment;

  Uint8List? _sharedGroupKey = null;

  final Map<int, Uint8List> _encryptedSecrets = {};

  /// A map that contains all received commitments.
  /// The key is the uid of the participant and the value
  /// is the [GPMainCommitment] sent by the participant.
  final Map<int, GPMainCommitment> _receivedCommitments = {};

  /// A map that contains all received valid main reveals
  /// (i.e., main reveals that were [GPMainReveal.verify]d for
  /// the [GPMainCommmitment] in [_receivedCommitments]).
  final Map<int, GPMainReveal> _receivedValidMainReveals = {};

  /// A set of uid's that we received a match reveal from.
  final Set<int> _uidReceivedMatchReveal = {};

  /// The [GPMainReveal.userData] received by each user ID
  /// and processed by [userDataParser].
  final Map<int, T> _receivedUserData = {};

  /// A lock used by [step] to ensure that only one
  /// [step] call is executed at a time.
  bool _lock = false;

  /// Function used to parse the [GPMainReveal.userData]
  /// and return a [T] object.
  final T? Function(String userData) userDataParser;

  /// Callback that is called whenever the protocol state changes.
  ///
  /// The callback can be changed on the fly. If the value is null,
  /// the callback is not called.
  Function(GroupPairingState oldState, GroupPairingState newState)?
      onStateChange;

  /// Callback that is called whenever the protocol instantiates a new
  /// [GroupPairingCommunicationInterface].
  ///
  /// The callback can be changed on the fly. If the value is null,
  /// the callback is not called.
  void Function(GroupPairingCommunicationInterface newComm)?
      onCommunicationChange;

  /// The [userData] of the owner of the [GroupPairingProtocol].
  final String userData;

  /// Instantiate a new [GroupPairingProtocol] object in the
  /// coordinator role.
  GroupPairingProtocol.coordinator(
      this._audioChannel, this._comm, this.userData, this.userDataParser,
      {this.settings = GrouppairingProtocolSettings.standard,
      this.onStateChange})
      : _isCoordinator = true {
    _updateState(GroupPairingState.coordinatorInit);
    _stateStopwatch.start();
  }

  /// Instantiate a new [GroupPairingProtocol] object in the
  /// device role.
  GroupPairingProtocol.device(
      this._audioChannel, this.userData, this.userDataParser,
      {this.settings = GrouppairingProtocolSettings.standard,
      this.onStateChange})
      : _isCoordinator = false {
    _updateState(GroupPairingState.deviceInit1);
    _stateStopwatch.start();
  }

  /// Whether the protocol is still running.
  ///
  /// The protocol is no longer when it is in either
  /// [GroupPairingState.done], [GroupPairingState.timeout],
  /// or [GroupPairingState.error].
  bool get isActive =>
      _state != GroupPairingState.timeout &&
      _state != GroupPairingState.error &&
      _state != GroupPairingState.done;

  /// The user ID of the owner of the [GroupPairingProtocol].
  int get ownUid => _commitment.uid;

  /// Returns a read-only copy of the received user data objects [T].
  Map<int, T> get receivedUserData => Map.unmodifiable(_receivedUserData);

  /// Returns the current state.
  GroupPairingState get state => _state;

  /// Returns a read-only copy of the state history.
  List<GroupPairingState> get stateHistory => List.unmodifiable(_stateHistory);

  int get timeoutMs => _timeoutStopwatch.elapsedMilliseconds;

  /// Runs the group pairing protocol.
  ///
  /// Needs to be called periodically (~1s) to keep the protocol running.
  /// Returns immediately when the protocol is no longer [isActive]
  /// or another [step] call is still running.
  Future<void> step() async {
    // if in TIMEOUT, ERROR or DONE state => return
    if (!isActive) return;

    // this is safe because there are no concurrent threads in dart
    // https://stackoverflow.com/questions/25067164/i-need-mutex-in-dart
    if (_lock) return;
    _lock = true;

    // execute inner step function, catch any exceptions and rethrow them
    // but always unlock the protocol
    try {
      await _step();
    } catch (e) {
      // When not active:
      // On any error, update the state to ERROR.
      if (isActive) {
        _updateState(GroupPairingState.error);
      }
      rethrow;
    } finally {
      _lock = false;
    }
  }

  /// When the protocol is in [GroupPairingState.userConfirm],
  /// used to let the user either verify or reject the pairing process.
  Future<void> userInputApprove(bool success) async {
    assert(_state == GroupPairingState.userConfirm);
    if (success) {
      // If the user is the coordinator, check the audio channel for any messages
      // not sent by us. This would indicate that someone tries to attack
      // the group pairing process.
      if (_isCoordinator) {
        final receivedMessages = await _audioChannel.getAllReceivedData();
        for (final received in receivedMessages) {
          if (!_transmittedAudioChannelMessages.any(
                  (transmitted) => listEquals(received, transmitted))) {
            await _error(UserConfirmFailedException());
            return;
          }
        }
        await _audioChannel.stopReceiving();
      }

      _updateState(GroupPairingState.sendMatchReveal);
    } else {
      await _error(UserConfirmFailedException());
    }
  }

  /// Check whether any wrong nonces were revealed over
  /// the communication channel [_comm].
  Future<bool> _anyWrongReceived() async {
    var receivedWrongReveals = await _comm.pollWrongReveals();

    return receivedWrongReveals.any((element) {
      var mainReveal = _receivedValidMainReveals[element.uid];
      return mainReveal != null && element.verify(mainReveal);
    });
  }

  /// Calculate the verification code based on the [_receivedValidMainReveals].
  Uint8List _calculateVerificationCode() {
    var comparisonBuffer = BytesBuilder();
    // go through the received main reveals based on uid
    for (var uid in _receivedValidMainReveals.keys.toList()..sort()) {
      var reveal = _receivedValidMainReveals[uid]!;
      comparisonBuffer.add(reveal.hashN);
      comparisonBuffer.add(utf8.encode(reveal.uid.toString()));
      comparisonBuffer.add(reveal.dhPublicKey);
      comparisonBuffer.add(reveal.encryptedUserData);
    }
    return gpDigest(comparisonBuffer.toBytes())
        .sublist(0, settings.verificationCodeLength);
  }

  /// Update the state to [GroupPairingState.error] and throw the [exception].
  /// If available, publish the own wrong reveal.
  Future<void> _error(GroupPairingException exception) async {
    // don't publich the wrong reveal unless the main reveal
    // was published
    if (_state.index > GroupPairingState.sendMainReveal.index) {
      await _comm.sendWrongReveal(_commitment.getWrongReveal());
    }
    _updateState(GroupPairingState.error);
    throw exception;
  }

  Future<void> _step() async {
    debugPrint("GroupPairingProtocol - _step");

    // check if any valid wrong reveals were received
    // if so, directly proceed to publishing the own wrong reveal
    if (_state.index > GroupPairingState.collectMainReveals.index &&
        await _anyWrongReceived()) {
      await _error(ReceivedWrongRevealException());
      assert(false); // the previous function call will throw
    }

    do {
      _processNext = false;

      switch (state) {
        case GroupPairingState.coordinatorInit:
          await _stepINIT_COORDINATOR();
          break;
        case GroupPairingState.deviceInit1:
          await _stepDEVICE_INIT1();
          break;
        case GroupPairingState.deviceInit2:
          await _stepDEVICE_INIT2();
          break;
        case GroupPairingState.establishingConnection:
          await _stepESTABLISHING_CONNECTION();
          break;
        case GroupPairingState.sendCommitment:
          await _stepSEND_COMMITMENT();
          break;
        case GroupPairingState.collectCommitments:
          await _stepCOLLECT_COMMITMENTS();
          break;
        case GroupPairingState.sendMainReveal:
          await _stepSEND_MAIN_REVEAL();
          break;
        case GroupPairingState.collectMainReveals:
          await _stepCOLLECT_MAIN_REVEALS();
          break;
        case GroupPairingState.secretSharing:
          await _stepSECRET_SHARING();
          break;
        case GroupPairingState.decrypting:
          await _stepDECRYPTING();
          break;
        case GroupPairingState.coordinatorVerification:
          await _stepCOORDINATOR_VERIFICATION();
          break;
        case GroupPairingState.deviceVerification1:
          await _stepDEVICE_VERIFICATION1();
          break;
        case GroupPairingState.deviceVerification2:
          await _stepDEVICE_VERIFICATION2();
          break;
        case GroupPairingState.userConfirm:
          await _stepUSER_CONFIRM();
          break;
        case GroupPairingState.sendMatchReveal:
          await _stepSEND_MATCH_REVEAL();
          break;
        case GroupPairingState.collectMatchReveals:
          await _stepCOLLECT_MATCH_REVEALS();
          break;
        default:
          // switch-case statement is complete
          // except for TIMEOUT, ERROR, and DONE
          // those states are excluded by the first if-statement in this function
          assert(false);
      }
    } while (_processNext && isActive);
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepCOLLECT_COMMITMENTS() async {
    List<GPMainCommitment> commitments = await _comm.pollMainCommitments();
    for (var element in commitments) {
      if (!_receivedCommitments.containsKey(element.uid)) {
        _receivedCommitments[element.uid] = element;
      }
    }

    if (_receivedCommitments.length == _comm.participantCount) {
      _updateState(GroupPairingState.sendMainReveal, processNext: true);
    } else if (_receivedCommitments.length > _comm.participantCount) {
      await _error(TooManyCommitmentsException(
          _receivedCommitments.length, _comm.participantCount));
    } else if (_timeoutStopwatch.elapsedMilliseconds >
        settings.commitmentCollectTimeoutMs) {
      _timeout();
    } else {
      // not enough commitments and no timeout
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepCOLLECT_MAIN_REVEALS() async {
    List<GPMainReveal> mainReveals = await _comm.pollMainReveals();
    for (var element in mainReveals) {
      if (_receivedCommitments.containsKey(element.uid)) {
        if (element.verify(_receivedCommitments[element.uid]!)) {
            _receivedValidMainReveals[element.uid] = element;
        }
      }
    }

    if (_receivedValidMainReveals.length == _comm.participantCount) {
      if (_isCoordinator) {
        _updateState(GroupPairingState.coordinatorVerification,
            processNext: true);
      } else {
        _updateState(GroupPairingState.deviceVerification1, processNext: true);
      }
    } else if (_timeoutStopwatch.elapsedMilliseconds >
        settings.mainRevealCollectTimeoutMs) {
      _timeout();
    } else {
      // not enough reveals and no timeout
      // _receivedValidMainReveals can contain at most
      // _receivedCommitments.length elements
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepCOLLECT_MATCH_REVEALS() async {
    List<GPMatchWrongReveal> reveals = await _comm.pollMatchReveals();
    for (var element in reveals) {
      if (!_uidReceivedMatchReveal.contains(element.uid) &&
          _receivedValidMainReveals.containsKey(element.uid)) {
        if (element.verify(_receivedValidMainReveals[element.uid]!)) {
          _uidReceivedMatchReveal.add(element.uid);
        }
      }
    }

    if (_uidReceivedMatchReveal.length == _comm.participantCount) {
      _updateState(GroupPairingState.secretSharing, processNext: true);
    } else if (_timeoutStopwatch.elapsedMilliseconds >
        settings.matchRevealCollectTimeoutMs) {
      _timeout();
    } else {
      // not enough reveals and no timeout
    }
  }

  List<MapEntry<String, GPMainReveal>> _sortedReveals = [];
  late final int _myIndex;
  bool _dhFinished = false;

  /// The idea for this step is the following:
  /// Since the participants only have a connection to the coordinator, they
  /// need to send their DH result and encrypted secret to the coordinator,
  /// which forwards it to all other participants. At the same time, the coordinator
  /// is responsible for instructing each participant to do their DH calculations.
  /// The DH tree demands a strict order in which the shared secret is calculated.
  /// The encrypted secret is included in each message to save a few RTTs.
  ///
  /// The exchange scales linearly (O(n)) with the number of participants.
  Future<void> _stepSECRET_SHARING() async {
    if (_sortedReveals.isEmpty) {
      _sortedReveals = _receivedValidMainReveals.values
          .map((e) => MapEntry(e.getCommitmentHash(), e))
          .toList()
        ..sort((e1, e2) => e1.key.compareTo(e2.key));
      _myIndex = _sortedReveals.indexWhere((element) => element.value.uid == _commitment.uid);
    }

    // The first and second participant in the DH tree have a special case:
    // they don't perform DH with an intermediate value (calculated by someone else),
    // but rather, they take the other participant's public key directly.
    // The case for the second participant is handled in a different place.
    if (_myIndex == 0 && !_dhFinished) {
      final uidToSend = _isCoordinator ? _nextUidForDH(_commitment.uid) : _commitment.uid;
      final publicKey = _sortedReveals[1].value.dhPublicKey;
      _doDHAndSend(uidToSend, publicKey);
      _dhFinished = true;
    } else {
      // Wait for a packet to be received
      final receivedPacket = await _comm.pollSecret();
      if (receivedPacket == null) {
        return;
      }
      // Update received encrypted encryption secrets
      if (receivedPacket.secretUid != _commitment.uid) {
        _encryptedSecrets[receivedPacket.secretUid] = receivedPacket.encryptedSecret;
      }

      if (_isCoordinator) {
        await _stepSECRET_SHARING_coordinator(receivedPacket);
      } else {
        await _stepSECRET_SHARING_participant(receivedPacket);
      }
    }

    // When all encryption secrets have been received (n-1), go to next state.
    if (_encryptedSecrets.length == _sortedReveals.length - 1) {
      _updateState(GroupPairingState.decrypting, processNext: true);
    }
  }

  Future<void> _stepSECRET_SHARING_coordinator(GPSecretSharingPacket receivedPacket) async {
    // Forward the received encrypted secret to all participants.
    // At the same time, instruct the next participant to do their DH calculations.
    final nextUid = _nextUidForDH(receivedPacket.dhUid);
    final packet = GPSecretSharingPacket(nextUid, receivedPacket.dhPublicKey, receivedPacket.secretUid, receivedPacket.encryptedSecret);
    await _comm.sendSecret(packet);

    // If the next participant is me, then I do my part (since I can't receive my own forwarded packet).
    // Special case if I'm the second participant: ignore the received DH result
    // and use the first participant's public key directly instead.
    if (nextUid == _commitment.uid) {
      final nextUid = _nextUidForDH(_commitment.uid);
      final publicKey = _myIndex == 1 ? _sortedReveals[0].value.dhPublicKey : receivedPacket.dhPublicKey;
      await _doDHAndSend(nextUid, publicKey);
    }
  }

  Future<void> _stepSECRET_SHARING_participant(GPSecretSharingPacket receivedPacket) async {
    // If it's my turn, calculate the next DH tree node and send it to the coordinator
    // Special case if I'm the second participant: ignore the received DH result
    // and use the first participant's public key directly instead.
    if (receivedPacket.dhUid == _commitment.uid) {
      final publicKey = _myIndex == 1 ? _sortedReveals[0].value.dhPublicKey : receivedPacket.dhPublicKey;
      await _doDHAndSend(_commitment.uid, publicKey);
    }
  }

  Future<void> _doDHAndSend(int dhUid, Uint8List publicKeyForDH) async {
    final receivedPublicKey = _cryptoService.deserializePublicKey(publicKeyForDH);
    final dhResult = _cryptoService.singleDHAgreement(_commitment.dhKeyPair.privateKey, receivedPublicKey);
    final otherDHPublicKeys = _sortedReveals.sublist(max(2, _myIndex + 1)) // start with at least index 2
        .map((e) => e.value.dhPublicKey)
        .map(_cryptoService.deserializePublicKey);
    _sharedGroupKey = _cryptoService.deriveGroupKey(dhResult, otherDHPublicKeys);
    final encryptedSecret = _cryptoService.encryptUserData(_sharedGroupKey!, _commitment.nonceMatch);

    final packet = GPSecretSharingPacket(dhUid, _cryptoService.serializePublicKey(dhResult.publicKey), _commitment.uid, encryptedSecret);
    await _comm.sendSecret(packet);
  }

  int _nextUidForDH(int currentUid) {
    int currentIndex = _sortedReveals.indexWhere((element) => element.value.uid == currentUid);
    int nextUid;
    if (currentIndex >= 0) {
      if (currentIndex < _sortedReveals.length - 1) {
        nextUid = _sortedReveals[currentIndex + 1].value.uid;
      } else {
        nextUid = -1;
      }
    } else {
      throw ProtocolException("Unknown UID");
    }

    return nextUid;
  }

  Future<void> _stepDECRYPTING() async {
    _encryptedSecrets.forEach((uid, encryptedSecret) {
      final decryptedSecret = _cryptoService.decryptUserData(_sharedGroupKey!, encryptedSecret);
      final decryptedUserData = _cryptoService.decryptUserData(decryptedSecret, _receivedValidMainReveals[uid]!.encryptedUserData);
      final userData = userDataParser(utf8.decode(decryptedUserData));
      if (userData != null) {
        _receivedUserData[uid] = userData;
      }
    });

    _updateState(GroupPairingState.done);
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepCOORDINATOR_VERIFICATION() async {
    await Future.delayed(
        Duration(milliseconds: settings.verificationSentWaitMs));
    var verificationCode = _calculateVerificationCode();
    await _audioChannel.startTransmission(verificationCode);
    _transmittedAudioChannelMessages.add(verificationCode);
    await _audioChannel.stopTransmission();
    _updateState(GroupPairingState.userConfirm);
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepDEVICE_INIT1() async {
    _timeoutStopwatch.reset();
    _timeoutStopwatch.start();

    await _audioChannel.startReceiving();
    _updateState(GroupPairingState.deviceInit2, processNext: true);
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepDEVICE_INIT2() async {
    Uint8List? recvInitData = await _audioChannel.getReceivedData();
    if (recvInitData != null) {
      // received init data
      _comm =
          await GroupPairingCommunicationInterface.fromInitData(recvInitData);
      if (onCommunicationChange != null) {
        onCommunicationChange!(_comm);
      }

      await _audioChannel.stopReceiving();
      _timeoutStopwatch.reset();
      _timeoutStopwatch.start();
      _updateState(GroupPairingState.establishingConnection,
          processNext: true);
    } else if (_timeoutStopwatch.elapsedMilliseconds >
        settings.initDataTimeoutMs) {
      // no data received, but timeout
      _timeout();
    } else {
      debugPrint("ggwave - received data empty!");
      // no data received and no timeout => stay in same state
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepDEVICE_VERIFICATION1() async {
    _timeoutStopwatch.reset();
    _timeoutStopwatch.start();

    await _audioChannel.startReceiving();
    _updateState(GroupPairingState.deviceVerification2, processNext: true);
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepDEVICE_VERIFICATION2() async {
    Uint8List? recvData = await _audioChannel.getReceivedData();
    if (recvData != null) {
      await _audioChannel.stopReceiving();
      Uint8List expectedVerificationCode = _calculateVerificationCode();
      if (listEquals(recvData, expectedVerificationCode)) {
        _updateState(GroupPairingState.userConfirm);
      } else {
        await _error(
            VerificationFailedException(recvData, expectedVerificationCode));
      }
    } else if (_timeoutStopwatch.elapsedMilliseconds >
        settings.verificationTimeoutMs) {
      _timeout();
    } else {
      // no verification code received and not timeout => stay in same state
    }
  }

  int _initAudioRetransmissionCount = 0;
  // ignore: non_constant_identifier_names
  Future<void> _stepESTABLISHING_CONNECTION() async {
    if (await _comm.establishConnection()) {
      await _audioChannel.stopTransmission();
      _updateState(GroupPairingState.sendCommitment, processNext: true);
    } else if (_timeoutStopwatch.elapsedMilliseconds >
        settings.connectionTimeoutMs) {
      // connection not yet established but timeout
      await _audioChannel.stopTransmission();
      _timeout();
    } else if (_isCoordinator && _timeoutStopwatch.elapsedMilliseconds > (_initAudioRetransmissionCount + 1) * settings.audioRetransmissionTimeoutMs) {
      final initData = _comm.getInitData();
      await _audioChannel.startTransmission(initData);
      _transmittedAudioChannelMessages.add(initData);
      _initAudioRetransmissionCount += 1;
    } else {
      // connection not yet established and no timeout => stay in same state
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepINIT_COORDINATOR() async {
    Uint8List initData = _comm.getInitData();
    await _audioChannel.startReceiving();
    await _audioChannel.startTransmission(initData);
    _transmittedAudioChannelMessages.add(initData);
    _timeoutStopwatch.reset();
    _timeoutStopwatch.start();
    _updateState(GroupPairingState.establishingConnection, processNext: true);
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepSEND_COMMITMENT() async {
    var uid = await _comm.getUid();
    _commitment = GPCommitment(_cryptoService, uid, settings.nonceLength, userData);
    await _comm.sendMainCommitment(_commitment.getMainCommitment());
    _receivedCommitments[_commitment.uid] = _commitment.getMainCommitment();
    _updateState(GroupPairingState.collectCommitments);
    _timeoutStopwatch.reset();
    _timeoutStopwatch.start();
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepSEND_MAIN_REVEAL() async {
    var mainReveal = _commitment.getMainReveal();
    await _comm.sendMainReveal(mainReveal);
    _receivedValidMainReveals[_commitment.uid] = mainReveal;
    _updateState(GroupPairingState.collectMainReveals);
    _timeoutStopwatch.reset();
    _timeoutStopwatch.start();
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepSEND_MATCH_REVEAL() async {
    await _comm.sendMatchReveal(_commitment.getMatchReveal());
    _uidReceivedMatchReveal.add(_commitment.uid);
    _updateState(GroupPairingState.collectMatchReveals, processNext: true);
  }

  // ignore: non_constant_identifier_names
  Future<void> _stepUSER_CONFIRM() async {
    if (_timeoutStopwatch.elapsedMilliseconds >
        settings.matchRevealCollectTimeoutMs) {
      _timeout();
    }
  }

  Future<void> retransmitVerificationAudio() async {
    var verificationCode = _calculateVerificationCode();
    await _audioChannel.startTransmission(verificationCode);
    _transmittedAudioChannelMessages.add(verificationCode);
    await _audioChannel.stopTransmission();
  }

  /// Update the state to [GroupPairingState.timeout] and throw a [TimeoutException].
  void _timeout() {
    _timeoutStopwatch.stop();
    _updateState(GroupPairingState.timeout);
    throw TimeoutException(_timeoutStopwatch.elapsedMilliseconds,
        _stateHistory[_stateHistory.length - 2]);
  }

  void _updateState(GroupPairingState newState, {bool processNext = false}) {
    if (newState != _state) {
      debugPrint(
          "GroupPairingProtocol - _updateState: State $_state->$newState after ${_stateStopwatch.elapsedMilliseconds}ms (processNext=$processNext)");

      _state = newState;
      _stateHistory.add(newState);
      _processNext = processNext;
      _stateStopwatch.reset();

      if (onStateChange != null) {
        onStateChange!(_state, newState);
      }
    }
  }
}

enum GroupPairingState {
  init,
  coordinatorInit,
  deviceInit1,
  deviceInit2,
  establishingConnection,
  sendCommitment,
  collectCommitments,
  sendMainReveal,
  collectMainReveals,
  coordinatorVerification,
  deviceVerification1,
  deviceVerification2,
  userConfirm,
  sendMatchReveal,
  collectMatchReveals,
  secretSharing,
  decrypting,
  done,
  timeout,
  error
}
