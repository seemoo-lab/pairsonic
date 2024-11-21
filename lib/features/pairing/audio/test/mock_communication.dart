/// {@category GroupPairing}
library;

import 'dart:typed_data';

import '../interfaces/grouppairing_communication_interface.dart';
import '../models/grouppairing_models.dart';
import '../services/grouppairing_crypto_service_aes_gcm_ecdh.dart';

/// Mock implementation of [GroupPairingCommunicationInterface].
/// This implementation returns hardcoded values.
class GrouppairingMockCommunication
    implements GroupPairingCommunicationInterface {
  var timer = Stopwatch();
  static final cryptoService = GPCryptoServiceAES_GCM_ECDH();

  var comm1 = GPCommitment(cryptoService, 3162, 64,
      '{"userId":"10","name":"test1","bio":"","verified":0,"iconId":143}');
  var comm2 = GPCommitment(cryptoService, 72223, 64,
      '{"userId":"12","name":"test2","bio":"","verified":0,"iconId":141}');

  GrouppairingMockCommunication(int participantCount) {
    assert(participantCount == 3);
    timer.start();
  }

  @override
  Future<bool> establishConnection() async {
    await Future.delayed(const Duration(seconds: 5));
    return true;
  }

  @override
  Uint8List getInitData() {
    // - 1 Byte: TYPE
    // - 1 Byte: participant count
    // - 4 Byte: Key
    var initData = Uint8List.fromList([99, 3, 219, 159, 193, 53]);
    return initData;
  }

  @override
  Future<int> getUid() async {
    return 15615;
  }

  @override
  int get participantCount => 3;

  @override
  int get connectionCount => 3;

  @override
  Future<List<GPMainCommitment>> pollMainCommitments() async {
    if (timer.elapsedMilliseconds > 2000) {
      return [comm1.getMainCommitment(), comm2.getMainCommitment()];
    }
    return [];
  }

  @override
  Future<List<GPMainReveal>> pollMainReveals() async {
    if (timer.elapsedMilliseconds > 3500) {
      return [comm2.getMainReveal(), comm1.getMainReveal()];
    } else if (timer.elapsedMilliseconds > 3000) {
      return [comm2.getMainReveal()];
    }
    return [];
  }

  @override
  Future<List<GPMatchWrongReveal>> pollMatchReveals() async {
    return [
      comm1.getMatchReveal(),
      comm2.getMatchReveal(),
      comm1.getMatchReveal()
    ];
  }

  @override
  Future<void> sendMainCommitment(GPMainCommitment commitment) async {}

  @override
  Future<void> sendMainReveal(GPMainReveal reveal) async {}

  @override
  Future<void> sendMatchReveal(GPMatchWrongReveal reveal) async {}

  @override
  Future<List<GPMatchWrongReveal>> pollWrongReveals() async {
    return [];
  }

  @override
  Future<void> sendWrongReveal(GPMatchWrongReveal reveal) async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<GPSecretSharingPacket> pollSecret() async {
    return GPSecretSharingPacket(0, Uint8List(0), 0, Uint8List(0));
  }

  @override
  Future<void> sendSecret(GPSecretSharingPacket encryptedSecret) async {
  }
}
