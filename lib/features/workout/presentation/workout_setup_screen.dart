import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/app_radius.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/label/run_zone_body_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_headline_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_label_medium_label.dart';
import 'cubit/workout_setup_cubit.dart';

final class WorkoutSetupScreen extends StatelessWidget {
  const WorkoutSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutSetupCubit(),
      child: SafeArea(
        child: Padding(
          padding: AppSpacing.screenInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RunZoneHeadlineLargeLabel('운동 전 설정'),
              AppSpacing.titleDescriptionGap,
              const RunZoneBodyLargeLabel('오늘 운동에 사용할 목표와 기기 상태를 확인해요.'),
              const SizedBox(height: AppSpacing.controlGroupGap),
              BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
                builder: (context, state) {
                  return _WorkoutEnvironmentSelector(
                    selectedEnvironment: state.environment,
                    onSelectionChanged: context.read<WorkoutSetupCubit>().changeEnvironment,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _WorkoutEnvironmentSelector extends StatelessWidget {
  const _WorkoutEnvironmentSelector({required this.selectedEnvironment, required this.onSelectionChanged});

  final WorkoutEnvironment selectedEnvironment;
  final ValueChanged<WorkoutEnvironment> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: AppRadius.smallBorder),
      child: Padding(
        padding: AppSpacing.segmentedControlInsets,
        child: Row(
          spacing: AppSpacing.segmentedControlGap,
          children: [
            _buildEnvironmentButton(context, workoutEnvironment: WorkoutEnvironment.indoor, label: '실내 · 러닝머신'),
            _buildEnvironmentButton(context, workoutEnvironment: WorkoutEnvironment.outdoor, label: '야외 · GPS'),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentButton(
    BuildContext context, {
    required WorkoutEnvironment workoutEnvironment,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = selectedEnvironment == workoutEnvironment;

    return Expanded(
      child: Semantics(
        selected: isSelected,
        child: TextButton(
          onPressed: () => onSelectionChanged(workoutEnvironment),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(isSelected ? colorScheme.primary : Colors.transparent),
            shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: AppRadius.badgeBorder)),
          ),
          child: RunZoneLabelMediumLabel(
            label,
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
