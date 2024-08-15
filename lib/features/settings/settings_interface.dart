
/// Abstract class to define a service to save and load settings
///
/// {@category Interfaces}
abstract class SettingsService{
  Future init();

  void setBool(String key, bool value);
  void setInt(String key, int value);
  void setString(String key, String value);
  void setDouble(String key, double value);

  bool? getBool(String key);
  int? getInt(String key);
  String? getString(String key);
  double? getDouble(String key);
}