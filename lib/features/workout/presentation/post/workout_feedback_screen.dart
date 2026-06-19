import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/label/run_zone_body_large_label.dart';
import '../../../../core/design_system/widgets/label/run_zone_headline_large_label.dart';
import '../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import 'widgets/workout_perceived_exertion_selector.dart';
import 'workout_feedback_cubit.dart';

final class WorkoutFeedbackScreen extends StatelessWidget {
  const WorkoutFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => WorkoutFeedbackCubit(), child: const _WorkoutFeedbackView());
  }
}

final class _WorkoutFeedbackView extends StatelessWidget {
  const _WorkoutFeedbackView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: AppSpacing.screenInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const RunZoneHeadlineLargeLabel('오늘 어땠나요?', textAlign: TextAlign.center),
              AppSpacing.titleDescriptionGap,
              RunZoneBodyLargeLabel(
                '한 번만 기록하면 다음 훈련 추천이 정확해져요.',
                color: colorScheme.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
