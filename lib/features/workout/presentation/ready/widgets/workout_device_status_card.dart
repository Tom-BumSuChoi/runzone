import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/design_system/widgets/badge/run_zone_badge.dart';
import '../../../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../../../core/design_system/widgets/list/run_zone_list_item.dart';
import '../../../domain/workout_environment.dart';
import '../../../domain/workout_plan.dart';
import '../workout_ready_cubit.dart';
import 'workout_treadmill_pace_panel.dart';

final class WorkoutDeviceStatusCard extends StatelessWidget {
  const WorkoutDeviceStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutReadyCubit, WorkoutReadyState>(
      builder: (context, readyState) {
        return RunZoneCard(
          child: Column(
            children: [
              const RunZoneListItem(
                title: '심박 기기',
                subtitle: 'Polar H10 · 정상 수신 중',
                trailing: RunZoneBadge('정상', isHighlighted: true),
              ),
              if (readyState.environment == WorkoutEnvironment.indoor) ...[
                const Divider(),
                RunZoneListItem(
                  title: '러닝머신',
                  subtitle: readyState.isTreadmillConnected ? 'RUNZONE Treadmill · 연결됨' : '미연결',
                  trailing: Switch(
                    value: readyState.isTreadmillConnected,
                    onChanged: (_) {
                      context.read<WorkoutReadyCubit>().treadmillConnectionToggled();
                    },
                  ),
                ),
                if (readyState.isTreadmillConnected) ...[
                  const Divider(),
                  WorkoutTreadmillPacePanel(
                    canUseAutoPace: readyState.plan is! FreeWorkoutPlan,
                    isAutoPaceEnabled: readyState.isAutoPaceEnabled,
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
