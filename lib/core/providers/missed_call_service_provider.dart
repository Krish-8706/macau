import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macau/core/entities/call_log.dart';
import 'package:macau/core/services/missed_call_logger_service.dart';

// A StateNotifierProvider that exposes the list of missed call logs
final missedCallLoggerProvider =
    StateNotifierProvider<MissedCallLoggerNotifier, List<CallLog>>((ref) {
  return MissedCallLoggerNotifier();
});
