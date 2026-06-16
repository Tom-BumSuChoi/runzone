import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/badge/run_zone_badge.dart';
import '../../../core/design_system/widgets/button/run_zone_primary_button.dart';
import '../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../core/design_system/widgets/chip/run_zone_choice_chip.dart';
import '../../../core/design_system/widgets/control/run_zone_segmented_control.dart';
import '../../../core/design_system/widgets/label/run_zone_body_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_body_medium_label.dart';
import '../../../core/design_system/widgets/label/run_zone_body_small_label.dart';
import '../../../core/design_system/widgets/label/run_zone_headline_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../core/design_system/widgets/label/run_zone_title_medium_label.dart';
import '../../../core/design_system/widgets/stepper/run_zone_stepper.dart';
import '../domain/heart_rate_zone.dart';
import 'cubit/workout_setup_cubit.dart';

final class WorkoutSetupScreen extends StatelessWidget {
  const WorkoutSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutSetupCubit(),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.screenPadding,
                AppSpacing.screenPadding,
                0,
              ),
              child: SingleChildScrollView(
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
                    const _WorkoutGoalSection(),
                    AppSpacing.sectionGap,
                    const _WorkoutDeviceSectionLabel(),
                    AppSpacing.sectionLabelGap,
                    const _WorkoutDeviceStatusCard(),
                    AppSpacing.sectionGap,
                    const _WorkoutCoachingSection(),
                    const _WorkoutStartRequirementSection(),
                    AppSpacing.sectionGap,
                  ],
                ),
              ),
            ),
          ),
          Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;

              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: colorScheme.outline)),
                ),
                child: const Padding(padding: AppSpacing.screenInsets, child: _WorkoutStartButton()),
              );
            },
          ),
        ],
      ),
    );
  }
}

final class _WorkoutGoalSection extends StatelessWidget {
  const _WorkoutGoalSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        if (state.trainingType == WorkoutTrainingType.free) {
          return const SizedBox.shrink();
        }

        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.sectionGap,
            _WorkoutGoalSectionLabel(),
            AppSpacing.sectionLabelGap,
            _WorkoutGoalSummaryCard(),
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
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        final goalFields = state.trainingType.spec.goalFields;

        return RunZoneCard(
          child: Column(
            children: [
              for (final (index, field) in goalFields.indexed) ...[
                _WorkoutGoalField(field: field, state: state),
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
  const _WorkoutGoalField({required this.field, required this.state});

  final _WorkoutGoalFieldData field;
  final WorkoutSetupState state;

  @override
  Widget build(BuildContext context) {
    final value = switch (field.control) {
      _WorkoutGoalFieldControl.targetZoneDuration => '${state.targetZoneDurationGoal.minutes}분',
      _WorkoutGoalFieldControl.targetHeartRateZone => state.targetHeartRateZone.label,
      _WorkoutGoalFieldControl.none => field.value ?? (throw StateError('Workout goal field value is required.')),
    };
    final onDecrement = switch (field.control) {
      _WorkoutGoalFieldControl.targetZoneDuration => context.read<WorkoutSetupCubit>().decreaseTargetZoneDuration,
      _WorkoutGoalFieldControl.targetHeartRateZone => context.read<WorkoutSetupCubit>().decreaseTargetHeartRateZone,
      _WorkoutGoalFieldControl.none => () {},
    };
    final onIncrement = switch (field.control) {
      _WorkoutGoalFieldControl.targetZoneDuration => context.read<WorkoutSetupCubit>().increaseTargetZoneDuration,
      _WorkoutGoalFieldControl.targetHeartRateZone => context.read<WorkoutSetupCubit>().increaseTargetHeartRateZone,
      _WorkoutGoalFieldControl.none => () {},
    };

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [RunZoneBodyMediumLabel(field.label), RunZoneBodySmallLabel(field.description)],
        ),
        const Spacer(),
        if (!field.isAdjustable)
          RunZoneBadge(value)
        else
          RunZoneStepper(label: value, onDecrement: onDecrement, onIncrement: onIncrement),
      ],
    );
  }
}

enum _WorkoutGoalFieldControl { none, targetZoneDuration, targetHeartRateZone }

final class _WorkoutGoalFieldData {
  const _WorkoutGoalFieldData({
    required this.label,
    required this.description,
    this.value,
    this.isAdjustable = false,
    this.control = _WorkoutGoalFieldControl.none,
  });

  final String label;
  final String description;
  final String? value;
  final bool isAdjustable;
  final _WorkoutGoalFieldControl control;
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
    trainingType: WorkoutTrainingType.targetZone,
    label: '목표존 지속주',
    description: '선택한 심박존을 유지하며 안정적으로 달려요.',
    goalSectionLabel: '목표',
    goalFields: [
      _WorkoutGoalFieldData(
        label: '목표 시간',
        description: '운동 시작 후에도 조정 가능',
        isAdjustable: true,
        control: _WorkoutGoalFieldControl.targetZoneDuration,
      ),
      _WorkoutGoalFieldData(
        label: '목표 심박존',
        description: '선택한 심박존을 유지',
        isAdjustable: true,
        control: _WorkoutGoalFieldControl.targetHeartRateZone,
      ),
    ],
  ),
  _WorkoutTrainingTypeSpec(
    trainingType: WorkoutTrainingType.interval,
    label: '인터벌',
    description: '강도 구간과 회복 구간을 번갈아 달려요.',
    goalSectionLabel: '인터벌 구성',
    goalFields: [
      _WorkoutGoalFieldData(label: '워밍업', description: '몸을 천천히 올려요', value: '5분', isAdjustable: true),
      _WorkoutGoalFieldData(label: '고강도', description: '목표 Z4', value: '400m', isAdjustable: true),
      _WorkoutGoalFieldData(label: '회복', description: '목표 Z1-Z2', value: '90초', isAdjustable: true),
      _WorkoutGoalFieldData(label: '반복', description: '고강도와 회복 반복', value: '6회', isAdjustable: true),
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
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        return RunZoneCard(
          child: Column(
            children: [
              const Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [RunZoneBodyMediumLabel('심박 기기'), RunZoneBodySmallLabel('Polar H10 · 정상 수신 중')],
                  ),
                  Spacer(),
                  RunZoneBadge('정상', isHighlighted: true),
                ],
              ),
              if (state.environment == WorkoutEnvironment.indoor) ...[
                const Divider(),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RunZoneBodyMediumLabel('러닝머신'),
                        RunZoneBodySmallLabel(state.isTreadmillConnected ? 'RUNZONE Treadmill · 연결됨' : '미연결'),
                      ],
                    ),
                    const Spacer(),
                    Switch(
                      value: state.isTreadmillConnected,
                      onChanged: (_) => context.read<WorkoutSetupCubit>().toggleTreadmillConnection(),
                    ),
                  ],
                ),
                if (state.isTreadmillConnected) ...[
                  const Divider(),
                  _WorkoutTreadmillPacePanel(
                    canUseAutoPace: state.trainingType != WorkoutTrainingType.free,
                    isAutoPaceEnabled: state.isAutoPaceEnabled,
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

final class _WorkoutTreadmillPacePanel extends StatelessWidget {
  const _WorkoutTreadmillPacePanel({required this.canUseAutoPace, required this.isAutoPaceEnabled});

  final bool canUseAutoPace;
  final bool isAutoPaceEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (canUseAutoPace) ...[
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RunZoneBodyMediumLabel('자동 속도 조절'),
                    RunZoneBodySmallLabel(
                      isAutoPaceEnabled ? '심박이 목표 존을 벗어나면 페이스를 자동 조정해요' : '수동 모드 — 운동 중 ▲▼ 버튼으로 직접 조작',
                    ),
                  ],
                ),
              ),
              Switch(value: isAutoPaceEnabled, onChanged: (_) => context.read<WorkoutSetupCubit>().toggleAutoPace()),
            ],
          ),
          AppSpacing.controlGroupSpacer,
        ],
        Row(
          children: [
            Expanded(
              child: _WorkoutPaceMetric(
                label: '시작 속도',
                description: canUseAutoPace ? null : '운동 중 직접 조절할 수 있어요',
                value: '6',
                unit: 'km/h',
              ),
            ),
            if (canUseAutoPace && isAutoPaceEnabled) ...[
              const SizedBox(width: AppSpacing.chipGap),
              const Expanded(
                child: _WorkoutPaceMetric(label: '조정 폭', value: '±0.5', unit: 'km/h'),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

final class _WorkoutPaceMetric extends StatelessWidget {
  const _WorkoutPaceMetric({required this.label, required this.value, required this.unit, this.description});

  final String label;
  final String value;
  final String unit;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        RunZoneBodySmallLabel(label, textAlign: TextAlign.center),
        if (description case final description?) RunZoneBodySmallLabel(description, textAlign: TextAlign.center),
        RunZoneTitleMediumLabel(value, color: colorScheme.primary, textAlign: TextAlign.center),
        RunZoneLabelSmallLabel(unit, color: colorScheme.onSurfaceVariant, textAlign: TextAlign.center),
      ],
    );
  }
}

final class _WorkoutStartRequirementSection extends StatelessWidget {
  const _WorkoutStartRequirementSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        final message = switch ((state.isHeartRateDeviceConnected, state.canStart)) {
          (false, _) => '심박 기기 연결이 필요해요.',
          (true, false) => '러닝머신 연결이 필요해요.',
          (true, true) => null,
        };

        if (message == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [AppSpacing.sectionGap, _WorkoutStartRequirementCard(message)],
        );
      },
    );
  }
}

final class _WorkoutStartRequirementCard extends StatelessWidget {
  const _WorkoutStartRequirementCard(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, color: colorScheme.primary),
        AppSpacing.inlineLabelGap,
        Expanded(child: RunZoneBodyMediumLabel(message)),
      ],
    );
  }
}

final class _WorkoutStartButton extends StatelessWidget {
  const _WorkoutStartButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        return RunZonePrimaryButton(label: '운동 시작', onPressed: state.canStart ? () {} : null);
      },
    );
  }
}

final class _WorkoutCoachingSection extends StatelessWidget {
  const _WorkoutCoachingSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        if (state.trainingType == WorkoutTrainingType.free) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RunZoneLabelSmallLabel('코칭'),
            AppSpacing.sectionLabelGap,
            _WorkoutCoachingCard(isZoneAlertEnabled: state.isZoneAlertEnabled),
          ],
        );
      },
    );
  }
}

final class _WorkoutCoachingCard extends StatelessWidget {
  const _WorkoutCoachingCard({required this.isZoneAlertEnabled});

  final bool isZoneAlertEnabled;

  @override
  Widget build(BuildContext context) {
    return RunZoneCard(
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [RunZoneBodyMediumLabel('존 이탈 알림'), RunZoneBodySmallLabel('목표 존 밖 20초 이상 유지 시')],
          ),
          const Spacer(),
          Switch(value: isZoneAlertEnabled, onChanged: (_) => context.read<WorkoutSetupCubit>().toggleZoneAlert()),
        ],
      ),
    );
  }
}

extension on WorkoutEnvironment {
  String get deviceSectionLabel {
    return switch (this) {
      WorkoutEnvironment.indoor => '기기 상태',
      WorkoutEnvironment.outdoor => '기기 상태',
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
