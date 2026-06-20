import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../../../core/design_system/widgets/chip/run_zone_choice_chip.dart';
import '../../../../../core/design_system/widgets/label/run_zone_body_medium_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_body_small_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../../../core/design_system/widgets/stepper/run_zone_stepper.dart';
import '../../../../heart_rate/domain/heart_rate_zone.dart';
import '../../../domain/workout_duration_goal.dart';
import '../../../domain/workout_plan.dart';
import '../workout_ready_cubit.dart';

final class WorkoutPlanSection extends StatelessWidget {
  const WorkoutPlanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RunZoneLabelSmallLabel('훈련 종류'),
        AppSpacing.sectionLabelGap,
        const _WorkoutPlanChips(),
        AppSpacing.controlGroupSpacer,
        BlocBuilder<WorkoutReadyCubit, WorkoutReadyState>(
          builder: (context, state) {
            return RunZoneBodyMediumLabel(state.plan.spec.description);
          },
        ),
        const _WorkoutGoalSection(),
      ],
    );
  }
}

final class _WorkoutGoalSection extends StatelessWidget {
  const _WorkoutGoalSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutReadyCubit, WorkoutReadyState>(
      builder: (context, readyState) {
        if (readyState.plan is FreeWorkoutPlan) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.sectionGap,
            RunZoneLabelSmallLabel(readyState.plan.spec.goalSectionLabel),
            AppSpacing.sectionLabelGap,
            const _WorkoutGoalSummaryCard(),
          ],
        );
      },
    );
  }
}

final class _WorkoutGoalSummaryCard extends StatelessWidget {
  const _WorkoutGoalSummaryCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutReadyCubit, WorkoutReadyState>(
      builder: (context, state) {
        return switch (state.plan) {
          TargetZoneWorkoutPlan plan => _TargetZoneWorkoutGoalCard(plan: plan),
          IntervalWorkoutPlan plan => _IntervalWorkoutGoalCard(plan: plan),
          FreeWorkoutPlan() => const SizedBox.shrink(),
        };
      },
    );
  }
}

final class _TargetZoneWorkoutGoalCard extends StatelessWidget {
  const _TargetZoneWorkoutGoalCard({required this.plan});

  final TargetZoneWorkoutPlan plan;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WorkoutReadyCubit>();

    return RunZoneCard(
      child: Column(
        children: [
          _WorkoutGoalRow(
            label: '목표 시간',
            description: '운동 시작 후에도 조정 가능',
            control: RunZoneStepper(
              label: plan.durationGoal.label,
              onDecrement: cubit.targetZoneDurationDecreased,
              onIncrement: cubit.targetZoneDurationIncreased,
            ),
          ),
          const Divider(),
          _WorkoutGoalRow(
            label: '목표 심박존',
            description: '선택한 심박존을 유지',
            control: RunZoneStepper(
              label: plan.targetHeartRateZone.label,
              onDecrement: cubit.targetHeartRateZoneDecreased,
              onIncrement: cubit.targetHeartRateZoneIncreased,
            ),
          ),
        ],
      ),
    );
  }
}

final class _IntervalWorkoutGoalCard extends StatelessWidget {
  const _IntervalWorkoutGoalCard({required this.plan});

  final IntervalWorkoutPlan plan;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WorkoutReadyCubit>();

    return RunZoneCard(
      child: Column(
        children: [
          _WorkoutGoalRow(
            label: '워밍업',
            description: '몸을 천천히 올려요',
            control: RunZoneStepper(
              label: plan.warmUpDuration.minutesLabel,
              onDecrement: cubit.intervalWarmUpDurationDecreased,
              onIncrement: cubit.intervalWarmUpDurationIncreased,
            ),
          ),
          const Divider(),
          _WorkoutGoalRow(
            label: '고강도',
            description: '목표 Z4',
            control: RunZoneStepper(
              label: '${plan.highIntensityDistanceMeters}m',
              onDecrement: cubit.intervalHighIntensityDistanceDecreased,
              onIncrement: cubit.intervalHighIntensityDistanceIncreased,
            ),
          ),
          const Divider(),
          _WorkoutGoalRow(
            label: '회복',
            description: '목표 Z1-Z2',
            control: RunZoneStepper(
              label: plan.recoveryDuration.secondsLabel,
              onDecrement: cubit.intervalRecoveryDurationDecreased,
              onIncrement: cubit.intervalRecoveryDurationIncreased,
            ),
          ),
          const Divider(),
          _WorkoutGoalRow(
            label: '반복',
            description: '고강도와 회복 반복',
            control: RunZoneStepper(
              label: '${plan.repeatCount}회',
              onDecrement: cubit.intervalRepeatCountDecreased,
              onIncrement: cubit.intervalRepeatCountIncreased,
            ),
          ),
        ],
      ),
    );
  }
}

final class _WorkoutGoalRow extends StatelessWidget {
  const _WorkoutGoalRow({required this.label, required this.description, required this.control});

  final String label;
  final String description;
  final Widget control;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [RunZoneBodyMediumLabel(label), RunZoneBodySmallLabel(description)],
        ),
        const Spacer(),
        control,
      ],
    );
  }
}

final class _WorkoutPlanChips extends StatelessWidget {
  const _WorkoutPlanChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutReadyCubit, WorkoutReadyState>(
      builder: (context, readyState) {
        return Row(
          spacing: AppSpacing.chipGap,
          children: [
            for (final spec in _workoutPlanSpecs)
              RunZoneChoiceChip(
                label: spec.label,
                isSelected: spec.matches(readyState.plan),
                onTap: () => spec.select(context.read<WorkoutReadyCubit>()),
              ),
          ],
        );
      },
    );
  }
}

const _workoutPlanSpecs = [
  _WorkoutPlanSpec(
    plan: TargetZoneWorkoutPlan.initial,
    label: '목표존 지속주',
    description: '선택한 심박존을 유지하며 안정적으로 달려요.',
    goalSectionLabel: '목표',
  ),
  _WorkoutPlanSpec(
    plan: IntervalWorkoutPlan.initial,
    label: '인터벌',
    description: '강도 구간과 회복 구간을 번갈아 달려요.',
    goalSectionLabel: '인터벌 구성',
  ),
  _WorkoutPlanSpec(
    plan: FreeWorkoutPlan.initial,
    label: '자유 러닝',
    description: '정해진 목표 없이 바로 기록을 시작해요.',
    goalSectionLabel: '자유 러닝 설정',
  ),
];

final class _WorkoutPlanSpec {
  const _WorkoutPlanSpec({
    required this.plan,
    required this.label,
    required this.description,
    required this.goalSectionLabel,
  });

  final WorkoutPlan plan;
  final String label;
  final String description;
  final String goalSectionLabel;

  bool matches(WorkoutPlan selectedPlan) {
    return switch ((plan, selectedPlan)) {
      (TargetZoneWorkoutPlan(), TargetZoneWorkoutPlan()) => true,
      (IntervalWorkoutPlan(), IntervalWorkoutPlan()) => true,
      (FreeWorkoutPlan(), FreeWorkoutPlan()) => true,
      _ => false,
    };
  }

  void select(WorkoutReadyCubit cubit) {
    switch (plan) {
      case TargetZoneWorkoutPlan():
        cubit.targetZonePlanSelected();
      case IntervalWorkoutPlan():
        cubit.intervalPlanSelected();
      case FreeWorkoutPlan():
        cubit.freePlanSelected();
    }
  }
}

extension on WorkoutPlan {
  _WorkoutPlanSpec get spec {
    return _workoutPlanSpecs.firstWhere((spec) => spec.matches(this));
  }
}

extension on HeartRateZone {
  String get label {
    return switch (this) {
      HeartRateZone.zone1 => 'Z1',
      HeartRateZone.zone2 => 'Z2',
      HeartRateZone.zone3 => 'Z3',
      HeartRateZone.zone4 => 'Z4',
      HeartRateZone.zone5 => 'Z5',
    };
  }
}

extension on WorkoutDurationGoal {
  String get label => '$minutes분';
}

extension on Duration {
  String get minutesLabel => '$inMinutes분';

  String get secondsLabel => '$inSeconds초';
}
