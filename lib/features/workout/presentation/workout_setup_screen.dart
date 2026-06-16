import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/control/run_zone_segmented_control.dart';
import '../../../core/design_system/widgets/label/run_zone_body_large_label.dart';
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
            ],
          ),
        ),
      ),
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
