import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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

/// Concatenate two [Uint8List]s.
Uint8List concatBytes(Uint8List list1, Uint8List list2) {
  var bb = BytesBuilder();
  bb.add(list1);
  bb.add(list2);
  return bb.toBytes();
}
