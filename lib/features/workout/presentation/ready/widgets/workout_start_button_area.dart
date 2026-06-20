import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/widgets/button/run_zone_primary_button.dart';
import '../workout_ready_cubit.dart';

final class WorkoutStartButtonArea extends StatelessWidget {
  const WorkoutStartButtonArea({super.key, required this.onStartPressed});

  final VoidCallback onStartPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outline)),
      ),
      child: Padding(
        padding: AppSpacing.screenInsets,
        child: BlocBuilder<WorkoutReadyCubit, WorkoutReadyState>(
          builder: (context, readyState) {
            return RunZonePrimaryButton(
              label: '운동 시작',
              onPressed: readyState.canStart ? onStartPressed : null,
            );
          },
        ),
      ),
    );
  }
}
