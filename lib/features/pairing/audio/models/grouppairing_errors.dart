/// {@category GroupPairing}
library;

import 'dart:typed_data';

import 'package:pairsonic/features/pairing/audio/grouppairing_protocol.dart';

class BadUserDataException implements GroupPairingException {
  final String userData;
  final dynamic cause;

  BadUserDataException(this.userData, [this.cause]);

  @override
  String toString() {
    return "Received bad user data: \"$userData\" ${cause != null ? '$cause' : ''}";
  }
}

class GroupPairingException implements Exception {}

class ReceivedWrongRevealException implements GroupPairingException {
  ReceivedWrongRevealException();

  @override
  String toString() {
    return "Received wrong reveal matching a received main reveal";
  }
}

class TimeoutException implements GroupPairingException {
  final int afterMs;
  final GroupPairingState inState;

  TimeoutException(this.afterMs, this.inState);

  @override
  String toString() {
    return "Grouppairing timeout after ${afterMs}ms in state $inState";
  }
}

class TooManyCommitmentsException implements GroupPairingException {
  final int got;
  final int expected;

  TooManyCommitmentsException(this.got, this.expected);

  @override
  String toString() {
    return "Received $got commitments, expected $expected";
  }
}

class UserConfirmFailedException implements GroupPairingException {
  UserConfirmFailedException();

  @override
  String toString() {
    return "The user did not confirm that all users verified the code correctly";
  }
}

class VerificationFailedException implements GroupPairingException {
  final Uint8List got;
  final Uint8List expected;

  VerificationFailedException(this.got, this.expected);

  @override
  String toString() {
    return "Received $got as verification code but expected $expected";
  }
}
