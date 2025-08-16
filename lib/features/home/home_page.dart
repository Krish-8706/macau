import 'package:flutter/material.dart';
import 'package:macau/core/services/missed_call_service.dart';
import 'package:macau/core/services/ringer_mode_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _ringerService = RingerModeService();
  final _missedCallService = MissedCallService();

  final List<String> _missedCalls = [];

  @override
  void initState() {
    super.initState();
    _listenToMissedCalls();
  }

  void _listenToMissedCalls() {
    _missedCallService.missedCallStream.listen((call) {
      setState(() {
        _missedCalls.insert(0, call); // latest on top
      });
    });
  }

  Future<void> _setMode(int mode) async {
    await _ringerService.setRingerMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringer & Missed Calls'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => _setMode(0),
                icon: const Icon(Icons.notifications_off),
                label: const Text("Silent"),
              ),
              ElevatedButton.icon(
                onPressed: () => _setMode(1),
                icon: const Icon(Icons.vibration),
                label: const Text("Vibrate"),
              ),
              ElevatedButton.icon(
                onPressed: () => _setMode(2),
                icon: const Icon(Icons.notifications_active),
                label: const Text("Ringer"),
              ),
            ],
          ),

          const SizedBox(height: 30),
          const Divider(),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Missed Calls",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: _missedCalls.isEmpty
                ? const Center(child: Text("No missed calls yet"))
                : ListView.builder(
                    itemCount: _missedCalls.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.call_missed, color: Colors.red),
                        title: Text(_missedCalls[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
