import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/chip/run_zone_choice_chip.dart';
import '../../../core/design_system/widgets/control/run_zone_segmented_control.dart';
import '../../../core/design_system/widgets/label/run_zone_body_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_body_medium_label.dart';
import '../../../core/design_system/widgets/label/run_zone_headline_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
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
              AppSpacing.controlGroupSpacer,
              const _WorkoutEnvironmentControl(),
              AppSpacing.sectionGap,
              const RunZoneLabelSmallLabel('훈련 종류'),
              AppSpacing.sectionLabelGap,
              const _WorkoutTrainingTypeChips(),
              AppSpacing.controlGroupSpacer,
              const _WorkoutTrainingTypeDescription(),
            ],
          ),
        ),
      ),
    );
  }
}

final class _WorkoutTrainingTypeChips extends StatelessWidget {
  const _WorkoutTrainingTypeChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        return Row(
          spacing: AppSpacing.chipGap,
          children: [
            for (final option in _trainingTypeOptions)
              RunZoneChoiceChip(
                label: option.label,
                isSelected: state.trainingType == option.trainingType,
                onTap: () => context.read<WorkoutSetupCubit>().changeTrainingType(option.trainingType),
              ),
          ],
        );
      },
    );
  }
}

final class _WorkoutTrainingTypeDescription extends StatelessWidget {
  const _WorkoutTrainingTypeDescription();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        final selectedOption = _trainingTypeOptions.firstWhere((option) => option.trainingType == state.trainingType);

        return RunZoneBodyMediumLabel(selectedOption.description);
      },
    );
  }
}

const _trainingTypeOptions = [
  _WorkoutTrainingTypeOption(
    trainingType: WorkoutTrainingType.zoneTwo,
    label: '존2 지속주',
    description: 'Zone 2를 유지하며 안정적으로 달려요.',
  ),
  _WorkoutTrainingTypeOption(
    trainingType: WorkoutTrainingType.interval,
    label: '인터벌',
    description: '강도 구간과 회복 구간을 번갈아 달려요.',
  ),
  _WorkoutTrainingTypeOption(
    trainingType: WorkoutTrainingType.free,
    label: '자유 러닝',
    description: '정해진 목표 없이 바로 기록을 시작해요.',
  ),
];

final class _WorkoutTrainingTypeOption {
  const _WorkoutTrainingTypeOption({required this.trainingType, required this.label, required this.description});

  final WorkoutTrainingType trainingType;
  final String label;
  final String description;
}

final class _WorkoutEnvironmentControl extends StatelessWidget {
  const _WorkoutEnvironmentControl();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        return RunZoneSegmentedControl<WorkoutEnvironment>(
          selectedValue: state.environment,
          onChanged: context.read<WorkoutSetupCubit>().changeEnvironment,
          options: const [
            RunZoneSegmentedControlOption(value: WorkoutEnvironment.indoor, label: '실내 · 러닝머신'),
            RunZoneSegmentedControlOption(value: WorkoutEnvironment.outdoor, label: '야외 · GPS'),
          ],
        );
      },
    );
  }
}
