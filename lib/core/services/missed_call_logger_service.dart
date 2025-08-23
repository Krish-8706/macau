import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:macau/core/entities/call_log.dart';
import 'package:macau/core/services/missed_call_event_service.dart';
import 'package:macau/core/services/ringer_mode_service.dart';

class MissedCallLoggerNotifier extends StateNotifier<List<CallLog>> {
  final MissedCallEventService _missedCallService = MissedCallEventService();
  final Box<CallLog> _box = Hive.box<CallLog>('callLogs');

  MissedCallLoggerNotifier() : super([]) {
    // Load initial logs
    state = _box.values.toList();

    RingerModeService.checkNotificationListenerPermission();

    // Start listening for missed call events
    _missedCallService.missedCallStream.listen((call) async {
      print("Missed Call from ${call.caller}");
      addCallLog(call);
      deleteOldLogs();
      if (await RingerModeService.getCurrentRingerMode() != 2 &&
          checkDuplicates()) {
        RingerModeService.setRingerMode(2);
      }
    });
  }

  static Future<void> initialiseHive() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CallLogAdapter());
    }

    if (!Hive.isBoxOpen('callLogs')) {
      await Hive.openBox<CallLog>('callLogs');
    }
  }

  List<CallLog> getAllLogs() {
    return _box.values.toList();
  }

  void addCallLog(CallLog log) {
    _box.add(log);
    state = _box.values.toList();
  }

  void deleteLog(int index) {
    _box.deleteAt(index);
    state = _box.values.toList();
  }

  void clearLogs() {
    _box.clear();
    state = [];
  }

  void deleteOldLogs() {
    final now = DateTime.now();
    final keysToDelete = <dynamic>[];

    for (var entry in _box.toMap().entries) {
      final key = entry.key;
      final log = entry.value;

      if (now.difference(log.timeStamp).inMinutes > 5) {
        keysToDelete.add(key);
      }
    }

    _box.deleteAll(keysToDelete);
    state = _box.values.toList();
  }

  bool checkDuplicates() {
    final callsList = getAllLogs();
    Map<String, int> frequency = {};
    for (CallLog callLog in callsList) {
      frequency[callLog.caller] = (frequency[callLog.caller] ?? 0) + 1;
    }

    if (frequency.values.any((count) => count > 2)) {
      return true;
    }
    return false;
  }
}
