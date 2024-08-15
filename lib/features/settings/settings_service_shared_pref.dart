import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_interface.dart';

/// Implementation of [SettingsService] with SharedPreferences
///
/// {@category Services}
class SharedPrefSettingsService implements SettingsService{

  late SharedPreferences _preferenceStorage;

  @override
  Future init() async {
    debugPrint("SettingsService - create: Initializing SharedPreferences");
    _preferenceStorage = await SharedPreferences.getInstance();
    setDefaultValues();
  }

  void setDefaultValues(){
    if(_preferenceStorage.getString("language") == null) _preferenceStorage.setString("language", 'en');
    if(_preferenceStorage.getString("neighborhoodId") == null) _preferenceStorage.setString("neighborhoodId", 'Darmstadt');
    if(_preferenceStorage.getDouble("synchronizeIntervalForeground") == null) _preferenceStorage.setDouble("synchronizeIntervalForeground", 15.0);
    if (_preferenceStorage.getDouble("synchronizeIntervalBackground") == null) _preferenceStorage.setDouble("synchronizeIntervalBackground", 60.0);
  }

  @override
  bool? getBool(String key) {
    return _preferenceStorage.containsKey(key) ? _preferenceStorage.getBool(key)! : null;
  }

  @override
  double? getDouble(String key) {
    return _preferenceStorage.containsKey(key) ? _preferenceStorage.getDouble(key)! : null;
  }

  @override
  int? getInt(String key) {
    return _preferenceStorage.containsKey(key) ? _preferenceStorage.getInt(key)! : null;
  }

  @override
  String? getString(String key) {
    return _preferenceStorage.containsKey(key) ? _preferenceStorage.getString(key)! : null;
  }

  @override
  void setBool(String key, bool value) {
    _preferenceStorage.setBool(key,value);
  }

  @override
  void setDouble(String key, double value) {
    _preferenceStorage.setDouble(key,value);
  }

  @override
  void setInt(String key, int value) {
    _preferenceStorage.setInt(key,value);
  }

  @override
  void setString(String key, String value) {
    _preferenceStorage.setString(key,value);
  }

}