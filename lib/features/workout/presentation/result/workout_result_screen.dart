import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/app_spacing.dart';
import 'workout_result_cubit.dart';
import 'widgets/workout_result_completion_ring.dart';

final class WorkoutResultScreen extends StatelessWidget {
  const WorkoutResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: BlocBuilder<WorkoutResultCubit, WorkoutResultState>(
          builder: (context, state) {
            return const Padding(
              padding: AppSpacing.screenInsets,
              child: Column(children: [WorkoutResultCompletionRing()]),
            );
          },
        ),
      ),
    );
  }
}
