import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../features/workout/presentation/live/widgets/workout_treadmill_panel.dart';

@widgetbook.UseCase(name: 'Default', type: WorkoutTreadmillPanel, path: '[Workout]/Panel')
Widget buildWorkoutTreadmillPanelUseCase(BuildContext context) {
  final speed = context.knobs.double.slider(label: 'Speed', initialValue: 9.8, min: 0, max: 25);
  final isManualMode = context.knobs.boolean(label: 'Manual Mode', initialValue: false);
  final automaticStatusLabel = context.knobs.object.dropdown<String>(
    label: 'Auto Status',
    options: const ['AUTO · 속도 유지', 'AUTO · 속도 낮추는 중', 'AUTO · 속도 올리는 중', 'AUTO · 구간 속도'],
    initialOption: 'AUTO · 속도 유지',
  );

  return SizedBox(
    width: 360,
    child: WorkoutTreadmillPanel(
      speed: speed,
      isManualMode: isManualMode,
      statusLabel: isManualMode ? 'MANUAL · 사용자 조작' : automaticStatusLabel,
      onDecrease: () {},
      onIncrease: () {},
      onResetAutomaticMode: () {},
    ),
  );
}
