import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/badge/run_zone_badge.dart';
import '../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../core/design_system/widgets/chip/run_zone_choice_chip.dart';
import '../../../core/design_system/widgets/control/run_zone_segmented_control.dart';
import '../../../core/design_system/widgets/label/run_zone_body_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_body_medium_label.dart';
import '../../../core/design_system/widgets/label/run_zone_body_small_label.dart';
import '../../../core/design_system/widgets/label/run_zone_headline_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../core/design_system/widgets/stepper/run_zone_stepper.dart';
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
              AppSpacing.sectionGap,
              const _WorkoutGoalSectionLabel(),
              AppSpacing.sectionLabelGap,
              const _WorkoutGoalSummaryCard(),
              AppSpacing.sectionGap,
              const _WorkoutDeviceSectionLabel(),
              AppSpacing.sectionLabelGap,
              const _WorkoutDeviceStatusCard(),
            ],
          ),
        ),
      ),
    );
  }
}

final class _WorkoutGoalSummaryCard extends StatelessWidget {
  const _WorkoutGoalSummaryCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        final goalFields = state.trainingType.spec.goalFields;

        return RunZoneCard(
          child: Column(
            children: [
              for (final (index, field) in goalFields.indexed) ...[
                _WorkoutGoalField(field: field),
                if (index != goalFields.length - 1) const Divider(),
              ],
            ],
          ),
        );
      },
    );
  }
}

final class _WorkoutGoalField extends StatelessWidget {
  const _WorkoutGoalField({required this.field});

  final _WorkoutGoalFieldData field;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [RunZoneBodyMediumLabel(field.label), RunZoneBodySmallLabel(field.description)],
        ),
        const Spacer(),
        if (!field.isAdjustable)
          RunZoneBadge(field.value)
        else
          RunZoneStepper(label: field.value, onDecrement: () {}, onIncrement: () {}),
      ],
    );
  }
}

final class _WorkoutGoalFieldData {
  const _WorkoutGoalFieldData({
    required this.label,
    required this.description,
    required this.value,
    this.isAdjustable = false,
  });

  final String label;
  final String description;
  final String value;
  final bool isAdjustable;
}

final class _WorkoutGoalSectionLabel extends StatelessWidget {
  const _WorkoutGoalSectionLabel();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        return RunZoneLabelSmallLabel(state.trainingType.spec.goalSectionLabel);
      },
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
            for (final spec in _trainingTypeSpecs)
              RunZoneChoiceChip(
                label: spec.label,
                isSelected: state.trainingType == spec.trainingType,
                onTap: () => context.read<WorkoutSetupCubit>().changeTrainingType(spec.trainingType),
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
        return RunZoneBodyMediumLabel(state.trainingType.spec.description);
      },
    );
  }
}

const _trainingTypeSpecs = [
  _WorkoutTrainingTypeSpec(
    trainingType: WorkoutTrainingType.zoneTwo,
    label: '존2 지속주',
    description: 'Zone 2를 유지하며 안정적으로 달려요.',
    goalSectionLabel: '목표',
    goalFields: [
      _WorkoutGoalFieldData(label: '목표 시간', description: '운동 시작 후에도 조정 가능', value: '40분', isAdjustable: true),
      _WorkoutGoalFieldData(label: '목표 심박존', description: '지방 연소 / 기초 지구력', value: 'Z2', isAdjustable: true),
    ],
  ),
  _WorkoutTrainingTypeSpec(
    trainingType: WorkoutTrainingType.interval,
    label: '인터벌',
    description: '강도 구간과 회복 구간을 번갈아 달려요.',
    goalSectionLabel: '인터벌 구성',
    goalFields: [
      _WorkoutGoalFieldData(label: '워밍업', description: '몸을 천천히 올려요', value: '5분', isAdjustable: true),
      _WorkoutGoalFieldData(label: '반복 횟수', description: '고강도와 회복 반복', value: '6회', isAdjustable: true),
    ],
  ),
  _WorkoutTrainingTypeSpec(
    trainingType: WorkoutTrainingType.free,
    label: '자유 러닝',
    description: '정해진 목표 없이 바로 기록을 시작해요.',
    goalSectionLabel: '자유 러닝 설정',
    goalFields: [
      _WorkoutGoalFieldData(label: '목표 시간', description: '정해진 시간 없이 기록', value: '없음'),
      _WorkoutGoalFieldData(label: '목표 심박존', description: '코칭보다 기록 중심', value: '자유'),
    ],
  ),
];

final class _WorkoutTrainingTypeSpec {
  const _WorkoutTrainingTypeSpec({
    required this.trainingType,
    required this.label,
    required this.description,
    required this.goalSectionLabel,
    required this.goalFields,
  });

  final WorkoutTrainingType trainingType;
  final String label;
  final String description;
  final String goalSectionLabel;
  final List<_WorkoutGoalFieldData> goalFields;
}

extension on WorkoutTrainingType {
  _WorkoutTrainingTypeSpec get spec {
    return _trainingTypeSpecs.firstWhere((spec) => spec.trainingType == this);
  }
}

final class _WorkoutDeviceSectionLabel extends StatelessWidget {
  const _WorkoutDeviceSectionLabel();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        return RunZoneLabelSmallLabel(state.environment.deviceSectionLabel);
      },
    );
  }
}

final class _WorkoutDeviceStatusCard extends StatelessWidget {
  const _WorkoutDeviceStatusCard();

  @override
  Widget build(BuildContext context) {
    return const RunZoneCard(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [RunZoneBodyMediumLabel('심박 기기'), RunZoneBodySmallLabel('Polar H10 · 정상 수신 중')],
          ),
          Spacer(),
          RunZoneBadge('정상', isHighlighted: true),
        ],
      ),
    );
  }
}

extension on WorkoutEnvironment {
  String get deviceSectionLabel {
    return switch (this) {
      WorkoutEnvironment.indoor => '기기 상태',
      WorkoutEnvironment.outdoor => '위치 · 기기',
    };
  }
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
