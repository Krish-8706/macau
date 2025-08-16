import 'package:flutter/services.dart';

class RingerModeService {
  static const _channel = MethodChannel('ringer_mode_channel');

  Future<void> setRingerMode(int mode) async {
    await _channel.invokeMethod('setRingerMode', {'mode': mode});
  }

  Future<void> checkNotificationListenerPermission() async {
    await _channel.invokeMethod('checkNotificationListenerPermission');
  }
}
