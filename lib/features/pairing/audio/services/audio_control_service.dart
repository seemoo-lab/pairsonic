import 'package:flutter/services.dart';

/// The [AudioControlService] allows the app to control the volume of the device
/// and request focus.
class AudioControlService {
  static const _platform = MethodChannel("audiocontrol");

  /// Sets the volume of the device to the given [volume].
  static Future<int> getMaxVolume() async {
    return await _platform.invokeMethod('get_max_volume');
  }

  /// Returns the current volume of the device.
  static Future<int> getCurrentVolume() async {
    return await _platform.invokeMethod('get_current_volume');
  }

  /// Sets the volume of the device to the given value.
  static Future<bool> setVolume(int volume) async {
    return await _platform.invokeMethod('set_volume', <String, dynamic>{
      'volume': volume,
    });
  }

  /// Requests focus from the platform. This will stop other apps from playing
  /// audio.
  static Future<bool> requestFocus() async {
    return await _platform.invokeMethod('request_focus');
  }

  /// Abandons focus from the platform. This will allow other apps to play audio.
  static Future<bool> abandonFocus() async {
    return await _platform.invokeMethod('abandon_focus');
  }

  static Future<bool> doesMicSupportNearUltrasound() async {
    return await _platform.invokeMethod('mic_support_ultrasound');
  }
  
  static Future<bool> doesSpeakerSupportNearUltrasound() async {
    return await _platform.invokeMethod('speaker_support_ultrasound');
  }
}
