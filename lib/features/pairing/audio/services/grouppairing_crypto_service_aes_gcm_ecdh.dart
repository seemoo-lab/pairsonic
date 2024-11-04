import 'dart:typed_data';

import 'package:pairsonic/features/pairing/audio/interfaces/grouppairing_crypto_service_interface.dart';
import 'package:pairsonic/helper_functions.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/key_derivators/ecdh_kdf.dart';

/// Implements the [GroupPairingCryptoServiceInterface] using the following primitives:
/// - AES in GCM mode for symmetric cryptography
/// - Elliptic Curve (NIST P-256) for Diffie-Hellman
// ignore: camel_case_types
class GPCryptoServiceAES_GCM_ECDH extends GroupPairingCryptoServiceInterface {
  static const int macSize = 16; // 16 bytes
  static const int nonceLen = 12; // 12 bytes
  /// NIST P-256 aka. secp256r1
  static final curve = ECCurve_secp256r1();

  @override
  Uint8List decryptUserData(Uint8List key, Uint8List encrypted) {
    final nonce = encrypted.sublist(encrypted.length - nonceLen);
    final ciphertext = encrypted.sublist(0, encrypted.length - nonceLen);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(
          false,
          AEADParameters(
            KeyParameter(key),
            macSize * 8,
            nonce,
            Uint8List(0),
          ));

    final plain = cipher.process(ciphertext);

    return plain;
  }

  @override
  Uint8List encryptUserData(Uint8List key, Uint8List userData) {
    var nonce = randomBytes(nonceLen);
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
          true,
          AEADParameters(
            KeyParameter(key),
            macSize * 8,
            nonce,
            Uint8List(0), // empty associated data
          ));

    final ciphertext = cipher.process(userData);

    return Uint8List.fromList(ciphertext + nonce);
  }

  @override
  AsymmetricKeyPair<PublicKey, PrivateKey> generateDHKeyPair() {
    final keyParams = ECKeyGeneratorParameters(curve);
    final random = FortunaRandom()..seed(KeyParameter(_randomSeed()));
    final gen = ECKeyGenerator()..init(ParametersWithRandom(keyParams, random));

    return gen.generateKeyPair();
  }

  @override
  Uint8List serializePublicKey(PublicKey publicKey) {
    return (publicKey as ECPublicKey).Q!.getEncoded();
  }

  @override
  PublicKey deserializePublicKey(Uint8List bytes) {
    final q = curve.curve.decodePoint(bytes);
    return ECPublicKey(q, curve);
  }

  @override
  AsymmetricKeyPair singleDHAgreement(PrivateKey privatePart, PublicKey remainingPublicParts) {
    final private = privatePart as ECPrivateKey;
    final public = remainingPublicParts as ECPublicKey;

    final agreement = ECDHBasicAgreement()..init(private);
    final resultPrivate = ECPrivateKey(agreement.calculateAgreement(public), curve);
    final resultPublic = ECPublicKey(curve.G * resultPrivate.d!, curve);

    return AsymmetricKeyPair(resultPublic, resultPrivate);
  }

  /// privateKey = current k_i
  /// publicParts = br_j with j > i
  /// If remainingPublicParts is empty, keyPair is transformed into a symmetric key
  /// else, DH is performed with each remaining key
  @override
  Uint8List deriveGroupKey(AsymmetricKeyPair keyPair, Iterable<PublicKey> remainingPublicParts) {
    var keyPairI = keyPair;
    for (var publicPart in remainingPublicParts) {
      keyPairI = singleDHAgreement(keyPairI.privateKey, publicPart);
    }
    return _deriveSymmetricKey(keyPairI);
  }

  Uint8List _deriveSymmetricKey(AsymmetricKeyPair keyPair) {
    final params = ECDHKDFParameters(keyPair.privateKey as ECPrivateKey, keyPair.publicKey as ECPublicKey);
    final kdf = ECDHKeyDerivator()..init(params);

    return kdf.process(Uint8List(0));
  }

  Uint8List _randomSeed() => randomBytes(32);
}
