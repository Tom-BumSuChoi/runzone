import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/label/run_zone_body_large_label.dart';
import '../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import 'workout_ready_cubit.dart';
import 'widgets/workout_coaching_section.dart';
import 'widgets/workout_device_status_card.dart';
import 'widgets/workout_environment_control.dart';
import 'widgets/workout_plan_section.dart';
import 'widgets/workout_ready_header.dart';
import 'widgets/workout_start_button_area.dart';
import 'widgets/workout_start_requirement_section.dart';

final class WorkoutReadyScreen extends StatelessWidget {
  const WorkoutReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: AppSpacing.screenInsets,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WorkoutReadyHeader(onClosePressed: () => context.read<WorkoutReadyCubit>().closeTapped()),
                    AppSpacing.titleDescriptionGap,
                    const RunZoneBodyLargeLabel('오늘 운동에 사용할 목표와 기기 상태를 확인해요.'),
                    AppSpacing.controlGroupSpacer,
                    const WorkoutEnvironmentControl(),
                    AppSpacing.sectionGap,
                    const WorkoutPlanSection(),
                    AppSpacing.sectionGap,
                    const RunZoneLabelSmallLabel('기기 상태'),
                    AppSpacing.sectionLabelGap,
                    const WorkoutDeviceStatusCard(),
                    AppSpacing.sectionGap,
                    const WorkoutCoachingSection(),
                    const WorkoutStartRequirementSection(),
                  ],
                ),
              ),
            ),
          ),
          WorkoutStartButtonArea(onStartPressed: () => context.read<WorkoutReadyCubit>().startWorkoutTapped()),
        ],
      ),
    );
  }
}
