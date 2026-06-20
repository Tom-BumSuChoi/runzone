import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/button/run_zone_ghost_button.dart';
import '../../../../core/design_system/widgets/button/run_zone_primary_button.dart';
import '../../../../core/design_system/widgets/label/run_zone_body_large_label.dart';
import '../../../../core/design_system/widgets/label/run_zone_headline_large_label.dart';
import '../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import 'workout_feedback_cubit.dart';
import 'widgets/workout_feedback_note_field.dart';
import 'widgets/workout_mood_selector.dart';
import 'widgets/workout_perceived_exertion_selector.dart';

final class WorkoutFeedbackScreen extends StatelessWidget {
  const WorkoutFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: AppSpacing.screenInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const RunZoneHeadlineLargeLabel('오늘 어땠나요?'),
              AppSpacing.titleDescriptionGap,
              RunZoneBodyLargeLabel('한 번만 기록하면 다음 훈련 추천이 정확해져요.', color: colorScheme.onSurfaceVariant),
              AppSpacing.sectionGap,
              const RunZoneLabelSmallLabel('체감 강도 (RPE)'),
              AppSpacing.sectionLabelGap,
              const WorkoutPerceivedExertionSelector(),
              AppSpacing.sectionLabelGap,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RunZoneLabelSmallLabel('아주 편함', color: colorScheme.onSurfaceVariant),
                  RunZoneLabelSmallLabel('최대', color: colorScheme.onSurfaceVariant),
                ],
              ),
              AppSpacing.sectionGap,
              const RunZoneLabelSmallLabel('컨디션'),
              AppSpacing.sectionLabelGap,
              const WorkoutMoodSelector(),
              AppSpacing.sectionGap,
              const RunZoneLabelSmallLabel('메모 (선택)'),
              AppSpacing.sectionLabelGap,
              const WorkoutFeedbackNoteField(),
              const Spacer(),
              RunZonePrimaryButton(
                label: '저장하고 결과 보기',
                onPressed: () => context.pushReplacement(
                  AppRoutes.workoutResult,
                  extra: context.read<WorkoutFeedbackCubit>().session,
                ),
              ),
              AppSpacing.buttonGap,
              RunZoneGhostButton(
                label: '건너뛰기',
                onPressed: () => context.pushReplacement(
                  AppRoutes.workoutResult,
                  extra: context.read<WorkoutFeedbackCubit>().session,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
