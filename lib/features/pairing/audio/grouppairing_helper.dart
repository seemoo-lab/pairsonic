/// {@category GroupPairing}
library;

import 'dart:typed_data';

import 'grouppairing_constants.dart';
import 'package:pointycastle/export.dart';

/// Hash function used by the group pairing protocol.
///
/// This hash function is used to create the commitments.
/// Currently it is instantiated using the bouncycastle
/// SHA3-512 hash function.
Uint8List gpDigest(Uint8List val) {
  var sha3 = SHA3Digest(512);
  sha3.update(val, 0, val.length);
  var out = Uint8List(64);
  sha3.doFinal(out, 0);
  return out;
}

/// Checks if the given [val] is a valid group pairing digest
/// based on its length and [gpDigestLenMin] and [gpDigestLenMax].
bool isValidGPDigestLength(int len) {
  return len >= gpDigestLenMin && len <= gpDigestLenMax;
}
