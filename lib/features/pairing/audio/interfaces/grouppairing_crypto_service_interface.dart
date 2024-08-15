import 'dart:typed_data';

import 'package:pointycastle/export.dart';

abstract class GroupPairingCryptoServiceInterface {
  Uint8List encryptUserData(Uint8List key, Uint8List userData);

  Uint8List decryptUserData(Uint8List key, Uint8List encrypted);

  AsymmetricKeyPair<PublicKey, PrivateKey> generateDHKeyPair();

  Uint8List serializePublicKey(PublicKey publicKey);

  PublicKey deserializePublicKey(Uint8List bytes);

  AsymmetricKeyPair<PublicKey, PrivateKey> singleDHAgreement(PrivateKey privatePart, PublicKey remainingPublicParts);

  Uint8List deriveGroupKey(AsymmetricKeyPair keyPair, Iterable<PublicKey> otherDHPublicKeys);
}