import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macau/core/services/missed_call_logger_service.dart';
import 'package:macau/features/home/home_page.dart';

Future<void> main() async {
  // Initialise Hive before running app
  await MissedCallLoggerNotifier.initialiseHive();

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ringer & Missed Calls',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
