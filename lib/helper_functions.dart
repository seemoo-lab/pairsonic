import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:typed_data/typed_data.dart';

/// Returns a timestamp as String with 'dd.MM HH:mm'
String getTimestampFormatted(DateTime timestamp) {
  final DateFormat formatter = DateFormat('dd.MM HH:mm');
  final String formatted = formatter.format(timestamp);
  return formatted;
}

/// [TextInputFormatter] that only allows
/// numbers between [min] and [max].
///
/// Taken from https://stackoverflow.com/a/68072967
/// Modified to use int instead of double
class NumericalRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return newValue;
    } else if (newValue.text.length > max.toString().length) {
      return oldValue;
    } else if (int.parse(newValue.text) < min) {
      return newValue.copyWith(text: min.toString());
    } else if (int.parse(newValue.text) > max) {
      return newValue.copyWith(text: max.toString());
    } else {
      return newValue;
    }
  }
}

Random _secureRandomness = Random.secure();

/// Returns [len] bytes of random data from a secure random source.
Uint8List randomBytes(int len) {
  var result = Uint8List(len);
  for (int i = 0; i < len; i++) {
    result[i] = _secureRandomness.nextInt(256); // >= 0 and < 256
  }
  return result;
}

int generateUid() {
  // return a random integer between 0 and 2^32-1
  // the probability of a collision is very small
  var rng = Random.secure();
  return rng.nextInt(0x7fffffff);
}

/// Concatenate two [Uint8List]s.
Uint8List concatBytes(Uint8List list1, Uint8List list2) {
  var bb = BytesBuilder();
  bb.add(list1);
  bb.add(list2);
  return bb.toBytes();
}


/// Converts the given [input] integer into a 4-byte little-endian Uint8Buffer.
Uint8List intToBytes(int input) {
  Uint8List output = Uint8List(4);
  for (int i = 3; i >= 0; i--) {
    output[i] = input % 256;
    input ~/= 256;
  }
  return output;
}


/// Converts a 4-byte Ulittle-endian Uint8Buffer into an integer.
int takeInt(Uint8Buffer input) {
  int output = 0;
  for (int i = 0; i < 4; i++) {
    output = output * 256 + input.removeAt(0);
  }
  return output;
}

/// Removes the first [n] elements from [input] and returns them.
Uint8List takeN(int n, Uint8Buffer input) {
  Uint8List output = Uint8List(n);
  for (int i = 0; i < n; i++) {
    output[i] = input.removeAt(0);
  }
  return output;
}

String bytesToHex(Uint8List data) {
  final hexList = data.map((n) => (n <= 0xf ? "0" : "") + n.toRadixString(16));
  return "0x${hexList.join("")}";
}

extension HexString on Uint8List {
  String toHexString() {
    return bytesToHex(this);
  }
}