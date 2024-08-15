/// {@category GroupPairing}
library;

import 'dart:convert';

import 'package:pairsonic/features/pairing/audio/grouppairing_constants.dart';
import 'package:pairsonic/features/profile/user_model.dart';

import 'audio/models/grouppairing_errors.dart';

/// Returns a user based on the given [userData].
User? userJsonParserFunction(String userData) {
  if (userData.length > gpMaxUserdataLen) {
    throw BadUserDataException(userData, "JSON too long");
  }
  Map<String, dynamic> json = jsonDecode(userData);
  // we run group pairing => the user is verified
  json["verified"] = 1;
  var user = User.fromMap(json);
  // TODO possibly add more verifications
  return user;
}
