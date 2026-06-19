import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/design_system/widgets/control/run_zone_segmented_control.dart';
import '../../../domain/workout_environment.dart';
import '../workout_ready_cubit.dart';

final class WorkoutEnvironmentControl extends StatelessWidget {
  const WorkoutEnvironmentControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutReadyCubit, WorkoutReadyState>(
      builder: (context, readyState) {
        return RunZoneSegmentedControl<WorkoutEnvironment>(
          selectedValue: readyState.environment,
          onChanged: (environment) {
            final cubit = context.read<WorkoutReadyCubit>();
            switch (environment) {
              case WorkoutEnvironment.indoor:
                cubit.indoorEnvironmentTapped();
              case WorkoutEnvironment.outdoor:
                cubit.outdoorEnvironmentTapped();
            }
          },
          options: const [
            RunZoneSegmentedControlOption(value: WorkoutEnvironment.indoor, label: '실내 · 러닝머신'),
            RunZoneSegmentedControlOption(value: WorkoutEnvironment.outdoor, label: '야외 · GPS'),
          ],
        );
      },
    );
  }
}
