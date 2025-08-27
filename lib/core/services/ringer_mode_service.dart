import 'package:flutter/services.dart';

class RingerModeService {
  static const _channel = MethodChannel('ringer_mode_channel');

  static Future<void> setRingerMode(int mode) async {
    await _channel.invokeMethod('setRingerMode', {'mode': mode});
  }

  static Future<int?> getCurrentRingerMode() async {
    final int? mode = await _channel.invokeMethod<int>('getCurrentRingerMode');
    return mode; // 0 = silent, 1 = vibrate, 2 = normal
  }

  static Future<bool> checkNotificationListenerPermission() async {
    final granted = await _channel.invokeMethod<bool>(
      'checkNotificationListenerPermission',
    );
    return granted ?? false;
  }
}
