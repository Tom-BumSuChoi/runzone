import 'package:flutter/material.dart';
import 'package:runzone/core/design_system/app_spacing.dart';
import 'package:runzone/core/design_system/widgets/run_zone_progress_indicator.dart';

final class HeartRateZoneSetupScreen extends StatelessWidget {
  const HeartRateZoneSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenInsets,
          child: Column(
            crossAxisAlignment: .start,
            children: [RunZoneProgressIndicator(totalSteps: 2, currentStep: 2)],
          ),
        ),
      ),
    );
  }
}
