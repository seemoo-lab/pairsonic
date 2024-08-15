import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:sodium_libs/sodium_libs.dart';

extension KeyPairSerializer on KeyPair {
  Map<String, dynamic> toJson() => {
    "p": base64Encode(this.publicKey),
    "s": base64Encode(this.secretKey.extractBytes()),
  };
}

class CryptoService {
  // var _identityService = getIt<IdentityService>();
  // static final CryptoService _instance = CryptoService._();
  // factory CryptoService() => _instance;
  // late User _user;
  // Create storage
  final storage = const FlutterSecureStorage();
  late KeyPair _keyPair;
  late final Sodium sodium;

  CryptoService._();

  static Future<CryptoService> create() async {
    var cryptoService = CryptoService._();
    await cryptoService.init();
    return cryptoService;
  }

  Future init() async {
    // maybe reassign on every method call? -> user switched?
    // _user = _identityService.self;
    // Read value
    sodium = await SodiumInit.init();

    String? keyPairString = await storage.read(key: 'keyPair');
    if (keyPairString != null) {
      var json = jsonDecode(keyPairString);
      _keyPair = KeyPair(
        secretKey: SecureKey.fromList(
          sodium,
          base64Decode(json["s"]!),
        ),
        publicKey: base64Decode(json["p"]!),
      );
      return;
    }
    _keyPair = genKeyPair();
    storage.write(key: 'keyPair', value: jsonEncode(_keyPair.toJson()));
  }

  Uint8List getPublicKey() => _keyPair.publicKey;
  String getEncodedPublicKey() => base64Encode(getPublicKey());

  SecureKey _getPrivateKey() => _keyPair.secretKey;

  KeyPair genKeyPair() => sodium.crypto.sign.keyPair();

  SecureKey genHashKey() => sodium.crypto.genericHash.keygen();

  SecureKey stringToKey(String key) =>
      SecureKey.fromList(sodium, base64Decode(key));
  String keyToString(SecureKey key) => base64Encode(key.extractBytes());

  String hashString({required String message, SecureKey? key}) =>
      base64Encode(hash(message: decode(message), key: key));

  Uint8List hash({required Uint8List message, SecureKey? key}) =>
      sodium.crypto.genericHash.call(message: message, key: key);

  String signString(String message) => base64Encode(sign(decode(message)));

  Uint8List sign(Uint8List message) => sodium.crypto.sign.detached(
    message: message,
    secretKey: _getPrivateKey(),
  );

  bool verifyString(String message, String signature, String publicKey) =>
      verify(decode(message), base64Decode(signature), base64Decode(publicKey));

  bool verify(Uint8List message, Uint8List signature, Uint8List publicKey) =>
      sodium.crypto.sign.verifyDetached(
        message: message,
        signature: signature,
        publicKey: publicKey,
      );

  Uint8List decode(String s) => Uint8List.fromList(s.codeUnits);

  String encode(List<int> l) => String.fromCharCodes(l);
}
