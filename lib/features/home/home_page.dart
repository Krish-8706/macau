import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macau/core/providers/missed_call_service_provider.dart';
import 'package:macau/core/entities/call_log.dart';
import 'package:macau/core/services/ringer_mode_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String timeSince(DateTime dt) {
    final diff = DateTime.now().difference(dt);

    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hr ago";
    return "${diff.inDays} d ago";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missedCalls = ref.watch(missedCallLoggerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recent Missed Calls"),
      ),
      body: Column(
        children: [
          // Ringer mode buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => RingerModeService.setRingerMode(0),
                  icon: const Icon(Icons.notifications_off),
                  label: const Text("Silent"),
                ),
                ElevatedButton.icon(
                  onPressed: () => RingerModeService.setRingerMode(1),
                  icon: const Icon(Icons.vibration),
                  label: const Text("Vibrate"),
                ),
                ElevatedButton.icon(
                  onPressed: () => RingerModeService.setRingerMode(2),
                  icon: const Icon(Icons.notifications_active),
                  label: const Text("Ringer"),
                ),
              ],
            ),
          ),

          // Missed calls list
          Expanded(
            child: missedCalls.isEmpty
                ? const Center(
                    child: Text("No missed calls"),
                  )
                : ListView.builder(
                    itemCount: missedCalls.length,
                    itemBuilder: (context, index) {
                      final CallLog log = missedCalls[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.call_missed,
                          color: Colors.red,
                        ),
                        title: Text(log.caller),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(log.timeStamp.toString()),
                            Text(timeSince(log.timeStamp)),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
