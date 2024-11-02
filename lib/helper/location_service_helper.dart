import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pairsonic/generated/l10n.dart';

class LocationServiceHelper {
  static const channelName = "location_service";
  static const _channel = MethodChannel(channelName);
  
  static final LocationServiceHelper instance = LocationServiceHelper._();

  LocationServiceHelper._();

  Future<bool> isLocationServicesEnabled() async {
    final result = await _channel.invokeMethod("is_location_service_enabled");
    if (result != null && result is bool) {
      return result;
    }
    return false;
  }

  Future<void> showLocationServiceAlert(BuildContext context) async {
    await showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(S.of(context).alertLocationServiceTitle),
        content: Text(S.of(context).alertLocationServiceMessage),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _channel.invokeMethod("open_settings");
            },
            child: Text(S.of(context).alertLocationServiceButton),
          ),
        ],
      );
    });
  }
}