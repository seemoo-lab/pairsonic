/// {@category GroupPairing}
library;

import 'dart:typed_data';

import 'package:pairsonic/features/pairing/audio/models/grouppairing_models.dart';
import 'package:pairsonic/features/pairing/audio/test/mock_communication.dart';
import 'package:pairsonic/features/pairing/audio/wifip2p_communication.dart';

/// Interface that is to be implemented to provide
/// different communication options for the group pairing protocol.
/// Only the coordinator needs to select the communication method.
/// The participants initialize their [GroupPairingCommunicationInterface]
/// instance by creating it from the [initData] that is received
/// via an audio channel.
abstract class GroupPairingCommunicationInterface {
  /// Creates a new [GroupPairingCommunicationInterface] object for a
  /// given [initData].
  static Future<GroupPairingCommunicationInterface> fromInitData(
      Uint8List initData) async {
    switch (initData[0]) {
      case 1:
        return await GPWifiP2pCommunication.fromInitData(initData);
      case 99:
        // Not further init required for mock implementation
        return GrouppairingMockCommunication(initData[1]);
      default:
        throw UnimplementedError(
            "Unknown GrouppairingCommunication type requested");
    }
  }

  /// The number of intended participants as entered by the user
  int get participantCount;

  /// The number of currently active connections
  int get connectionCount;

  /// This function needs to be called periodically (e.g., once a second)
  /// to establish the connection for this communication scheme.
  /// Once the connection is established, this function returns true.
  /// Then it does not need to be called repeatedly and the communication can
  /// used.
  Future<bool> establishConnection();

  /// Returns the [initData] that can be used by another
  /// participant to initialize that same
  /// [GroupPairingCommunicationInterface] instance.
  Uint8List getInitData();

  /// Return a unique uid that is to be used by the group
  /// pairing protocol participant.
  /// This function is guaranteed to only be called once
  /// per group pairing protocol run.
  Future<int> getUid();

  Future<List<GPMainCommitment>> pollMainCommitments();
  Future<List<GPMainReveal>> pollMainReveals();
  Future<List<GPMatchWrongReveal>> pollMatchReveals();
  Future<List<GPMatchWrongReveal>> pollWrongReveals();
  Future<GPSecretSharingPacket?> pollSecret();

  Future<void> sendMainCommitment(GPMainCommitment commitment);
  Future<void> sendMainReveal(GPMainReveal reveal);
  Future<void> sendMatchReveal(GPMatchWrongReveal reveal);
  Future<void> sendWrongReveal(GPMatchWrongReveal reveal);
  Future<void> sendSecret(GPSecretSharingPacket encryptedSecret);

  Future<void> dispose();
}
