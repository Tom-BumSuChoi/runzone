import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/widgets/label/run_zone_body_small_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_title_medium_label.dart';
import '../../../../../core/design_system/widgets/list/run_zone_list_item.dart';
import '../workout_ready_cubit.dart';

final class WorkoutTreadmillPacePanel extends StatelessWidget {
  const WorkoutTreadmillPacePanel({super.key, required this.canUseAutoPace, required this.isAutoPaceEnabled});

  final bool canUseAutoPace;
  final bool isAutoPaceEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (canUseAutoPace) ...[
          RunZoneListItem(
            title: '자동 속도 조절',
            subtitle: isAutoPaceEnabled ? '심박이 목표 존을 벗어나면 페이스를 자동 조정해요' : '수동 모드 — 운동 중 ▲▼ 버튼으로 직접 조작',
            trailing: Switch(
              value: isAutoPaceEnabled,
              onChanged: (_) {
                context.read<WorkoutReadyCubit>().autoPaceToggled();
              },
            ),
          ),
          AppSpacing.controlGroupSpacer,
        ],
        Row(
          children: [
            Expanded(
              child: _WorkoutPaceMetric(
                label: '시작 속도',
                description: canUseAutoPace ? null : '운동 중 직접 조절할 수 있어요',
                value: '6',
                unit: 'km/h',
              ),
            ),
            if (canUseAutoPace && isAutoPaceEnabled) ...[
              const SizedBox(width: AppSpacing.chipGap),
              const Expanded(
                child: _WorkoutPaceMetric(label: '조정 폭', value: '±0.5', unit: 'km/h'),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

final class _WorkoutPaceMetric extends StatelessWidget {
  const _WorkoutPaceMetric({required this.label, required this.value, required this.unit, this.description});

  final String label;
  final String value;
  final String unit;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        RunZoneBodySmallLabel(label, textAlign: TextAlign.center),
        if (description case final description?) RunZoneBodySmallLabel(description, textAlign: TextAlign.center),
        RunZoneTitleMediumLabel(value, color: colorScheme.primary, textAlign: TextAlign.center),
        RunZoneLabelSmallLabel(unit, color: colorScheme.onSurfaceVariant, textAlign: TextAlign.center),
      ],
    );
  }
}
