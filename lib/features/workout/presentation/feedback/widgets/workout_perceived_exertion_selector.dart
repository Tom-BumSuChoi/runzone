import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/design_system/app_radius.dart';
import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/widgets/label/run_zone_label_large_label.dart';
import '../workout_feedback_cubit.dart';

final class WorkoutPerceivedExertionSelector extends StatelessWidget {
  const WorkoutPerceivedExertionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<WorkoutFeedbackCubit, WorkoutFeedbackState>(
      builder: (context, state) {
        return Row(
          spacing: AppSpacing.segmentedControlGap,
          children: [
            for (
              var value = WorkoutFeedbackState.minimumPerceivedExertion;
              value <= WorkoutFeedbackState.maximumPerceivedExertion;
              value++
            )
              Expanded(
                child: TextButton(
                  onPressed: () => context.read<WorkoutFeedbackCubit>().perceivedExertionSelected(value),
                  style: TextButton.styleFrom(
                    padding: AppSpacing.segmentedControlButtonInsets,
                    backgroundColor: value == state.perceivedExertion ? colorScheme.primary : null,
                    foregroundColor: value == state.perceivedExertion
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    side: BorderSide(
                      color: value == state.perceivedExertion ? Colors.transparent : colorScheme.outlineVariant,
                    ),
                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.badgeBorder),
                  ),
                  child: RunZoneLabelLargeLabel(
                    '$value',
                    color: value == state.perceivedExertion ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
