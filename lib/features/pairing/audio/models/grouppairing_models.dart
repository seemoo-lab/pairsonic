import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:convert/convert.dart';
import 'package:pairsonic/features/pairing/audio/grouppairing_helper.dart';
import 'package:pairsonic/features/pairing/audio/interfaces/grouppairing_crypto_service_interface.dart';
import 'package:pairsonic/helper_functions.dart';
import 'package:pointycastle/export.dart';

/// The first commitment submitted by participants
/// when group pairing.
class GPMainCommitment {
  /// An ID that uniquely identifies the user.
  final int uid;

  /// The main commitment of the user.
  final Uint8List commitment;

  const GPMainCommitment(this.uid, this.commitment);

  factory GPMainCommitment.fromMap(Map<String, dynamic> map) {
    return GPMainCommitment(
      map['userId'],
      base64.decode(map['data']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': uid,
      'data': base64.encode(commitment),
    };
  }
}

/// Used to reveal the values that one commited to in the main commitment.
class GPMainReveal {
  /// An ID that uniquely identifies the user.
  final int uid;

  /// The commitment of the wrong and match hashes.
  final Uint8List hashN;

  final Uint8List dhPublicKey;
  final Uint8List encryptedUserData;

  const GPMainReveal(this.uid, this.hashN, this.dhPublicKey, this.encryptedUserData);

  factory GPMainReveal.fromMap(Map<String, dynamic> map) {
    return GPMainReveal(
        map['userId'], base64.decode(map['hashN']), map['dhPublicKey'], map['encryptedUserData']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': uid,
      'hashN': base64.encode(hashN),
      'dhPublicKey': base64.encode(dhPublicKey),
      'encryptedUserData': base64.encode(encryptedUserData),
    };
  }

  /// Verify that this reveal is valid for the given commitment.
  bool verify(GPMainCommitment commitment) {
    var commitmentData =
        concatBytes(concatBytes(hashN, encryptedUserData), dhPublicKey);
    return listEquals(gpDigest(commitmentData), commitment.commitment);
  }

  String getCommitmentHash() {
    final commitment = concatBytes(concatBytes(hashN, encryptedUserData), dhPublicKey);
    final hashBytes = gpDigest(commitment);
    return hex.encoder.convert(hashBytes);
  }
}

/// Used to reveal either the wrong nonce or the match nonce.
/// This is used by the group pairing protocol to indicate success
/// or failure of the group pairing.
class GPMatchWrongReveal {
  /// An ID that uniquely identifies the user.
  final int uid;

  /// The nonce that will be revealed.
  final Uint8List nonce;

  /// The hash of the nonce that is NOT revealed.
  final Uint8List hash;

  /// Whether this reveal reveals the wrong nonce or the match nonce.
  final bool isMatch;

  const GPMatchWrongReveal(this.uid, this.nonce, this.hash, this.isMatch);

  factory GPMatchWrongReveal.fromMap(Map<String, dynamic> data) {
    return GPMatchWrongReveal(
      data['userId'],
      base64.decode(data['nonce']),
      base64.decode(data['hash']),
      data['isMatch'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': uid,
      'nonce': base64.encode(nonce),
      'hash': base64.encode(hash),
      'isMatch': isMatch,
    };
  }

  /// Verify that the reveal is valid for the given main reveal
  /// (checks against mainReveal.hashN).
  bool verify(GPMainReveal mainReveal) {
    var commitmentData = isMatch
        ? concatBytes(gpDigest(nonce), hash)
        : concatBytes(hash, gpDigest(nonce));
    return listEquals(gpDigest(commitmentData), mainReveal.hashN);
  }
}

/// Used by the group pairing protocol to generate the required
/// commitments and reveals. Internally it stores the nonces
/// and intermediate commitments.
class GPCommitment {
  final GroupPairingCryptoServiceInterface _cryptoService;
  final int uid;
  final Uint8List nonceMatch;
  final Uint8List nonceWrong;
  final String userData;
  // Hm
  late final Uint8List hashMatch;
  // Hm'
  late final Uint8List hashMatchPrime;
  // Hw
  late final Uint8List hashWrong;
  // HN
  late final Uint8List hashN;
  late final AsymmetricKeyPair<PublicKey, PrivateKey> dhKeyPair;
  late final Uint8List dhPublicBytes;
  late final Uint8List encryptedUserData;
  late final Uint8List commitment;

  GPCommitment(this._cryptoService, this.uid, int nonceLength, this.userData)
      : nonceMatch = randomBytes(nonceLength),
        nonceWrong = randomBytes(nonceLength) {
    hashMatch = gpDigest(nonceMatch);
    hashMatchPrime = gpDigest(hashMatch);
    hashWrong = gpDigest(nonceWrong);
    hashN = gpDigest(concatBytes(hashMatchPrime, hashWrong));

    dhKeyPair = _cryptoService.generateDHKeyPair();
    dhPublicBytes = _cryptoService.serializePublicKey(dhKeyPair.publicKey);

    var userDataBytes = Uint8List.fromList(utf8.encode(userData));
    encryptedUserData = _cryptoService.encryptUserData(nonceMatch, userDataBytes);

    var commitmentData =
        concatBytes(concatBytes(hashN, encryptedUserData), dhPublicBytes);
    commitment = gpDigest(commitmentData);
  }

  GPMainCommitment getMainCommitment() => GPMainCommitment(uid, commitment);
  GPMainReveal getMainReveal() => GPMainReveal(uid, hashN, dhPublicBytes, encryptedUserData);
  GPMatchWrongReveal getMatchReveal() =>
      GPMatchWrongReveal(uid, hashMatch, hashWrong, true); // (Hm, Hw)
  GPMatchWrongReveal getWrongReveal() =>
      GPMatchWrongReveal(uid, nonceWrong, hashMatchPrime, false); // (Hm', Nw)
}

/// A packet used for the DH key exchange and secret sharing stage.
class GPSecretSharingPacket {
  /// For messages from coordinator to participant, this is the UID of the participant who is next to do the DH exchange
  /// For messages from participant to coordinator, this is the participant's UID
  final int dhUid;
  /// The public part of the intermediate DH result (tree node)
  final Uint8List dhPublicKey;
  /// The UID of the participant, whose encrypted secret is appended
  final int secretUid;
  /// The secret with which the user data has been encrypted (= the match nonce Nm).
  /// This value is in turn encrypted with the shared secret derived through DH.
  final Uint8List encryptedSecret;

  GPSecretSharingPacket(
      this.dhUid, this.dhPublicKey, this.secretUid, this.encryptedSecret);
}
