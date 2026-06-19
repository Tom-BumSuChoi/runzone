import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/widgets/label/run_zone_label_large_label.dart';
import '../workout_feedback_cubit.dart';

final class WorkoutMoodSelector extends StatelessWidget {
  const WorkoutMoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<WorkoutFeedbackCubit, WorkoutFeedbackState>(
      builder: (context, state) {
        return Row(
          spacing: AppSpacing.chipGap,
          children: [
            for (final mood in WorkoutFeedbackMood.values)
              Expanded(
                child: TextButton(
                  onPressed: () => context.read<WorkoutFeedbackCubit>().moodSelected(mood),
                  style: TextButton.styleFrom(
                    backgroundColor: mood == state.mood ? colorScheme.primary.withValues(alpha: 0.2) : null,
                    foregroundColor: colorScheme.onSurfaceVariant,
                    side: BorderSide(color: mood == state.mood ? colorScheme.primary : colorScheme.outlineVariant),
                  ),
                  child: RunZoneLabelLargeLabel(
                    mood.label,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

extension on WorkoutFeedbackMood {
  String get label => switch (this) {
    WorkoutFeedbackMood.hard => '😣',
    WorkoutFeedbackMood.neutral => '😐',
    WorkoutFeedbackMood.good => '🙂',
    WorkoutFeedbackMood.great => '😄',
  };
}
