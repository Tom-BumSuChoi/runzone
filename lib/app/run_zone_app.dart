import 'package:flutter/material.dart';
import 'package:runzone/core/design_system/app_theme.dart';

final class RunZoneApp extends StatelessWidget {
  const RunZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run Zone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: AppTheme.themeMode,
      home: const Center(child: Text('Run Zone')),
    );
  }
}
