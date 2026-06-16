import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/badge/run_zone_badge.dart';
import '../../../core/design_system/widgets/button/run_zone_primary_button.dart';
import '../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../core/design_system/widgets/control/run_zone_segmented_control.dart';
import '../../../core/design_system/widgets/label/run_zone_body_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_body_medium_label.dart';
import '../../../core/design_system/widgets/label/run_zone_body_small_label.dart';
import '../../../core/design_system/widgets/label/run_zone_headline_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../core/design_system/widgets/label/run_zone_title_medium_label.dart';
import '../../../core/design_system/widgets/list/run_zone_list_item.dart';
import '../domain/workout_plan.dart';
import 'cubit/workout_setup_cubit.dart';
import 'widgets/workout_plan_section.dart';

final class WorkoutSetupScreen extends StatelessWidget {
  const WorkoutSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutSetupCubit(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                  const WorkoutPlanSection(),
                  AppSpacing.sectionGap,
                  const RunZoneLabelSmallLabel('기기 상태'),
                  AppSpacing.sectionLabelGap,
                  const _WorkoutDeviceStatusCard(),
                  AppSpacing.sectionGap,
                  const _WorkoutCoachingSection(),
                  const _WorkoutStartRequirementSection(),
                ],
              ),
            ),
          ),
          const _WorkoutStartButtonArea(),
        ],
      ),
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
              const RunZoneListItem(
                title: '심박 기기',
                subtitle: 'Polar H10 · 정상 수신 중',
                trailing: RunZoneBadge('정상', isHighlighted: true),
              ),
              if (state.environment == WorkoutEnvironment.indoor) ...[
                const Divider(),
                RunZoneListItem(
                  title: '러닝머신',
                  subtitle: state.isTreadmillConnected ? 'RUNZONE Treadmill · 연결됨' : '미연결',
                  trailing: Switch(
                    value: state.isTreadmillConnected,
                    onChanged: (_) => context.read<WorkoutSetupCubit>().toggleTreadmillConnection(),
                  ),
                ),
                if (state.isTreadmillConnected) ...[
                  const Divider(),
                  _WorkoutTreadmillPacePanel(
                    canUseAutoPace: state.plan is! FreeWorkoutPlan,
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
          RunZoneListItem(
            title: '자동 속도 조절',
            subtitle: isAutoPaceEnabled ? '심박이 목표 존을 벗어나면 페이스를 자동 조정해요' : '수동 모드 — 운동 중 ▲▼ 버튼으로 직접 조작',
            trailing: Switch(
              value: isAutoPaceEnabled,
              onChanged: (_) => context.read<WorkoutSetupCubit>().toggleAutoPace(),
            ),
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

final class _WorkoutStartButtonArea extends StatelessWidget {
  const _WorkoutStartButtonArea();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outline)),
      ),
      child: Padding(
        padding: AppSpacing.screenInsets,
        child: BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
          builder: (context, state) {
            return RunZonePrimaryButton(
              label: '운동 시작',
              onPressed: state.canStart ? () => _startWorkout(context) : null,
            );
          },
        ),
      ),
    );
  }

  void _startWorkout(BuildContext context) {
    Navigator.of(context).pop();
    context.go(AppRoutes.workoutCountdown);
  }
}

final class _WorkoutCoachingSection extends StatelessWidget {
  const _WorkoutCoachingSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutSetupCubit, WorkoutSetupState>(
      builder: (context, state) {
        if (state.plan is FreeWorkoutPlan) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RunZoneLabelSmallLabel('코칭'),
            AppSpacing.sectionLabelGap,
            RunZoneCard(
              child: RunZoneListItem(
                title: '존 이탈 알림',
                subtitle: '목표 존 밖 20초 이상 유지 시',
                trailing: Switch(
                  value: state.isZoneAlertEnabled,
                  onChanged: (_) => context.read<WorkoutSetupCubit>().toggleZoneAlert(),
                ),
              ),
            ),
          ],
        );
      },
    );
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
