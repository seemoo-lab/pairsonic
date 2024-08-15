import 'package:flutter/cupertino.dart';
import 'package:pairsonic/features/settings/settings_interface.dart';
import 'package:pairsonic/service_locator.dart';
import 'package:pairsonic/storage/crypto_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_model.dart';

/// Service providing the userId based on the hardwareId and user defined data such as name, bio, icon.
///
/// {@category Services}
class IdentityService {
  late SharedPreferences _preferenceStorage;
  late User self;
  var cryptoService = getIt<CryptoService>();
  bool identitySet = false;

  Future<String> get deviceId async {
    return _getOrSetDeviceId();
  }

  IdentityService._();

  static Future<IdentityService> create() async {
    debugPrint("IdentityService - create: Initializing SharedPreferences");
    final prefs = await SharedPreferences.getInstance();
    var identityService = IdentityService._();
    identityService._preferenceStorage = prefs;
    await identityService._getOrSetDeviceId();
    await identityService.initProfile();
    return identityService;
  }



  Future<bool> initProfile() async {
    SettingsService settingsService = getIt<SettingsService>();
    if (!identitySet) {
      String id = await _getOrSetDeviceId();

      if (settingsService.getString("userName") == null ||
          settingsService.getInt("userImage") == null ||
          settingsService.getString("userBio") == null) {
        //Profile not set
        self = User(id: id, name: "", bio: "", verified: true, iconId: 0);
      } else {
        self = User(
            id: id,
            name: settingsService.getString("userName")!,
            bio: settingsService.getString("userBio")!,
            verified: true,
            iconId: settingsService.getInt("userImage")!);
        identitySet = true;
      }
    }
    return identitySet;
  }


    void setOrUpdateProfile(User user) {
    SettingsService settingsService = getIt<SettingsService>();
    self = user;
    settingsService.setString("userName", user.name);
    settingsService.setInt("userImage", user.iconId);
    settingsService.setString("userBio", user.bio);
    identitySet = true;
  }

  void _writeDeviceId(String deviceId) {
    debugPrint("IdentityService - writeDeviceId: setting device id in shared preferences to $deviceId");
    this._preferenceStorage.setString("deviceId", deviceId);
  }

  Future<String> _getOrSetDeviceId() async {
    var actualDeviceId = _getActualDeviceId();
    var d = actualDeviceId;

    if (_preferenceStorage.containsKey("deviceId")) {
      try {
        var savedDeviceId = _preferenceStorage.getString('deviceId');
        if (actualDeviceId != savedDeviceId) {
          debugPrint("""IdentityService - create: Found deviceId in shared preferences but it does not match the actual
           deviceId. Replacing it!""");
          _writeDeviceId(actualDeviceId);
        } else if (savedDeviceId == null) {
          _writeDeviceId(actualDeviceId);
        } else {
          d = savedDeviceId;
        }
      } catch (e) {
        _writeDeviceId(actualDeviceId);
      }
    } else {
      _writeDeviceId(actualDeviceId);
    }

    return d;
  }

  String _getActualDeviceId() => getIt<CryptoService>().getEncodedPublicKey();
}

class IdentityServiceValueNotPresentException implements Exception {
  String valueName;

  IdentityServiceValueNotPresentException(this.valueName);
}
