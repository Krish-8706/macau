import 'package:flutter/services.dart';
import 'package:macau/core/entities/call_log.dart';

class MissedCallEventService {
  static const _eventChannel = EventChannel('missed_call_notifications');

  Stream<CallLog> get missedCallStream {
    return _eventChannel.receiveBroadcastStream().map(
      (event) => CallLog(
        caller: event.toString(),
        timeStamp: DateTime.now(),
      ),
    );
  }
}
