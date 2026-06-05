import 'package:flutter/material.dart';

final class RunZoneApp extends StatelessWidget {
  const RunZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run Zone',
      debugShowCheckedModeBanner: false,
      home: const Center(child: Text('Run Zone')),
    );
  }
}
