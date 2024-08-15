import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final _plugin = DeviceInfoPlugin();

  Future<int> getAndroidSDKVersion() async {
    final androidInfo = await _plugin.androidInfo;
    return androidInfo.version.sdkInt;
  }
}