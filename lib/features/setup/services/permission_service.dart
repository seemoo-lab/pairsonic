import 'package:flutter/cupertino.dart';
import 'package:pairsonic/generated/l10n.dart';
import 'package:pairsonic/helper/device_info_service.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Permissions to be used for Android 13 or later (SDK version >= 33)
  static const permissionsAfterAndroid13 = [
    Permission.microphone,
    Permission.nearbyWifiDevices,
    Permission.locationWhenInUse,
  ];

  /// Permissions to be used for Android 12 or earlier (SDK version < 33)
  static const permissionsBeforeAndroid13 = [
    Permission.microphone,
    Permission.locationWhenInUse,
  ];

  static final PermissionService instance = PermissionService();

  final _deviceInfoService = DeviceInfoService();

  Future<PermissionStatus> checkPermissions() async {
    var result = PermissionStatus.granted;
    final permissions = await _selectPermissionsBySDKVersion();

    for (final permission in permissions) {
      final status = await permission.status;
      if (status.isGranted) {
        continue;
      } else if (status.isDenied) {
        result = PermissionStatus.denied;
      } else if (status.isPermanentlyDenied) {
        // immediately return if one of the permissions is permanently denied
        return PermissionStatus.permanentlyDenied;
      }
    }

    return result;
  }

  Future<PermissionStatus> requestPermissions() async {
    var permissionStatus = PermissionStatus.granted;
    final permissions = await _selectPermissionsBySDKVersion();

    final result = await permissions.request();
    for (final status in result.values) {
      if (status.isGranted) {
        continue;
      } else if (status.isDenied) {
        permissionStatus = PermissionStatus.denied;
      } else if (status.isPermanentlyDenied) {
        // immediately return if one of the permissions is permanently denied
        return PermissionStatus.permanentlyDenied;
      }
    }
    return permissionStatus;
  }

  Future<List<(String, String)>> getPermissionNamesAndDescriptions(
      BuildContext context) async {
    final microphone = (
      S.of(context).permissionScreenNameMicrophone,
      S.of(context).permissionScreenDescriptionMicrophone
    );

    final nearbyDevices = (
      S.of(context).permissionScreenNameNearbyDevices,
      S.of(context).permissionScreenDescriptionNearbyDevices
    );

    final location = (
      S.of(context).permissionScreenNameLocation,
      S.of(context).permissionScreenDescriptionLocation
    );

    final sdkVersion = await _deviceInfoService.getAndroidSDKVersion();
    if (sdkVersion >= 33) {
      return [location, microphone, nearbyDevices];
    } else {
      return [location, microphone];
    }
  }

  Future<List<Permission>> _selectPermissionsBySDKVersion() async {
    final sdkVersion = await _deviceInfoService.getAndroidSDKVersion();
    if (sdkVersion >= 33) {
      return permissionsAfterAndroid13;
    } else {
      return permissionsBeforeAndroid13;
    }
  }
}
