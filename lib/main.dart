import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _requestNotificationListenerPermission();
  }

  Future<void> _requestNotificationListenerPermission() async {
    try {
      await MethodChannel(
        'ringer_mode_channel',
      ).invokeMethod('checkNotificationListenerPermission');
    } catch (e) {
      debugPrint('Error opening notification listener permission settings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Ringer Mode Toggle')),
        body: const Center(child: ToggleButton()),
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  const ToggleButton({super.key});

  static const MethodChannel _methodChannel = MethodChannel(
    'ringer_mode_channel',
  );
  static const EventChannel _eventChannel = EventChannel(
    'missed_call_notifications',
  );

  Future<void> toggleRingerMode() async {
    try {
      await _methodChannel.invokeMethod('toggleRingerMode');
    } on PlatformException catch (e) {
      debugPrint("Failed to toggle: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Your 3 mode buttons
        ElevatedButton(
          onPressed: () => RingerController.setRingerMode(0), // Silent
          child: const Text('Silent Mode'),
        ),
        ElevatedButton(
          onPressed: () => RingerController.setRingerMode(1), // Vibrate
          child: const Text('Vibrate Mode'),
        ),
        ElevatedButton(
          onPressed: () => RingerController.setRingerMode(2), // Normal
          child: const Text('Normal Mode'),
        ),

        const SizedBox(height: 20),

        // The missed calls notification list widget
        const Expanded(child: MissedCallNotifier()),
      ],
    );
  }
}

class RingerController {
  static const MethodChannel _channel = MethodChannel('ringer_mode_channel');

  /// mode: 0 = silent, 1 = vibrate, 2 = normal
  static Future<void> setRingerMode(int mode) async {
    try {
      await _channel.invokeMethod('setRingerMode', {'mode': mode});
    } on PlatformException catch (e) {
      print('Failed to set ringer mode: ${e.message}');
    }
  }
}

class MissedCallNotifier extends StatefulWidget {
  const MissedCallNotifier({super.key});

  @override
  _MissedCallNotifierState createState() => _MissedCallNotifierState();
}

class _MissedCallNotifierState extends State<MissedCallNotifier> {
  static const EventChannel _eventChannel = EventChannel(
    'missed_call_notifications',
  );
  final List<String> _missedCalls = [];

  @override
  void initState() {
    super.initState();
    _eventChannel.receiveBroadcastStream().listen(
      (event) {
        setState(() {
          _missedCalls.insert(0, event.toString()); // Newest on top
        });
      },
      onError: (error) {
        debugPrint('Error receiving missed call notifications: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_missedCalls.isEmpty) {
      return const Center(child: Text('No missed calls detected yet.'));
    }
    return ListView.builder(
      itemCount: _missedCalls.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.call_missed, color: Colors.red),
          title: Text(_missedCalls[index]),
        );
      },
    );
  }
}
