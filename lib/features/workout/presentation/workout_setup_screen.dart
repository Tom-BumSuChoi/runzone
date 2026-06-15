import 'package:flutter/material.dart';

import '../../../core/design_system/app_radius.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/label/run_zone_body_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_headline_large_label.dart';

final class WorkoutSetupScreen extends StatefulWidget {
  const WorkoutSetupScreen({super.key});

  @override
  State<WorkoutSetupScreen> createState() => _WorkoutSetupScreenState();
}

final class _WorkoutSetupScreenState extends State<WorkoutSetupScreen> {
  _WorkoutEnvironment _workoutEnvironment = _WorkoutEnvironment.indoor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RunZoneHeadlineLargeLabel('운동 전 설정'),
              AppSpacing.titleDescriptionGap,
              const RunZoneBodyLargeLabel('오늘 운동에 사용할 목표와 기기 상태를 확인해요.'),
              const SizedBox(height: AppSpacing.controlGroupGap),
              _WorkoutEnvironmentSelector(
                selectedEnvironment: _workoutEnvironment,
                onSelectionChanged: (workoutEnvironment) {
                  setState(() => _workoutEnvironment = workoutEnvironment);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _WorkoutEnvironment { indoor, outdoor }

final class _WorkoutEnvironmentSelector extends StatelessWidget {
  const _WorkoutEnvironmentSelector({required this.selectedEnvironment, required this.onSelectionChanged});

  final _WorkoutEnvironment selectedEnvironment;
  final ValueChanged<_WorkoutEnvironment> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: AppRadius.smallBorder),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          width: double.infinity,
          child: SegmentedButton<_WorkoutEnvironment>(
            showSelectedIcon: false,
            expandedInsets: EdgeInsets.zero,
            selected: {selectedEnvironment},
            onSelectionChanged: (selection) => onSelectionChanged(selection.first),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return colorScheme.primary;
                }
                return Colors.transparent;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return colorScheme.onPrimary;
                }
                return colorScheme.onSurfaceVariant;
              }),
              side: const WidgetStatePropertyAll(BorderSide(color: Colors.transparent)),
              shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: AppRadius.badgeBorder)),
              textStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
              visualDensity: VisualDensity.compact,
            ),
            segments: const [
              ButtonSegment<_WorkoutEnvironment>(value: _WorkoutEnvironment.indoor, label: Text('실내 · 러닝머신')),
              ButtonSegment<_WorkoutEnvironment>(value: _WorkoutEnvironment.outdoor, label: Text('야외 · GPS')),
            ],
          ),
        ),
      ),
    );
  }
}
