import 'package:flutter/material.dart';
import 'package:runzone/core/design_system/app_theme.dart';
import 'package:runzone/features/workout/presentation/heart_rate_zone_setup_screen.dart';

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
      home: const HeartRateZoneSetupScreen(),
    );
  }
}
