import 'package:flutter/services.dart';

class MissedCallService {
  static const _eventChannel = EventChannel('missed_call_notifications');

  Stream<String> get missedCallStream {
    return _eventChannel.receiveBroadcastStream().map(
      (event) => event.toString(),
    );
  }
}
