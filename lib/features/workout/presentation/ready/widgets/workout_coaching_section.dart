import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../../../core/design_system/widgets/list/run_zone_list_item.dart';
import '../../../domain/workout_plan.dart';
import '../workout_ready_cubit.dart';

final class WorkoutCoachingSection extends StatelessWidget {
  const WorkoutCoachingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutReadyCubit, WorkoutReadyState>(
      builder: (context, readyState) {
        if (readyState.plan is FreeWorkoutPlan) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RunZoneLabelSmallLabel('코칭'),
            AppSpacing.sectionLabelGap,
            RunZoneCard(
              child: RunZoneListItem(
                title: '존 이탈 알림',
                subtitle: '목표 존 밖 20초 이상 유지 시',
                trailing: Switch(
                  value: readyState.isZoneAlertEnabled,
                  onChanged: (_) {
                    context.read<WorkoutReadyCubit>().zoneAlertToggled();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
