import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/design_system/app_spacing.dart';
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
                    backgroundColor: value == state.perceivedExertion ? colorScheme.primary : null,
                    foregroundColor: value == state.perceivedExertion
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                  ),
                  child: Text('$value'),
                ),
              ),
          ],
        );
      },
    );
  }
}
