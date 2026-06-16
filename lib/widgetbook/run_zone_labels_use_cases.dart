import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/label/run_zone_body_large_label.dart';
import '../core/design_system/widgets/label/run_zone_body_medium_label.dart';
import '../core/design_system/widgets/label/run_zone_body_small_label.dart';
import '../core/design_system/widgets/label/run_zone_display_large_label.dart';
import '../core/design_system/widgets/label/run_zone_display_medium_label.dart';
import '../core/design_system/widgets/label/run_zone_display_small_label.dart';
import '../core/design_system/widgets/label/run_zone_headline_large_label.dart';
import '../core/design_system/widgets/label/run_zone_headline_medium_label.dart';
import '../core/design_system/widgets/label/run_zone_headline_small_label.dart';
import '../core/design_system/widgets/label/run_zone_label_large_label.dart';
import '../core/design_system/widgets/label/run_zone_label_medium_label.dart';
import '../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../core/design_system/widgets/label/run_zone_title_large_label.dart';
import '../core/design_system/widgets/label/run_zone_title_medium_label.dart';
import '../core/design_system/widgets/label/run_zone_title_small_label.dart';

const _defaultText = '런존';

@widgetbook.UseCase(name: 'Default', type: RunZoneDisplayLargeLabel, path: '[Design System]/Label')
Widget buildDisplayLargeLabelUseCase(BuildContext context) {
  return RunZoneDisplayLargeLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneDisplayMediumLabel, path: '[Design System]/Label')
Widget buildDisplayMediumLabelUseCase(BuildContext context) {
  return RunZoneDisplayMediumLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneDisplaySmallLabel, path: '[Design System]/Label')
Widget buildDisplaySmallLabelUseCase(BuildContext context) {
  return RunZoneDisplaySmallLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneHeadlineLargeLabel, path: '[Design System]/Label')
Widget buildHeadlineLargeLabelUseCase(BuildContext context) {
  return RunZoneHeadlineLargeLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneHeadlineMediumLabel, path: '[Design System]/Label')
Widget buildHeadlineMediumLabelUseCase(BuildContext context) {
  return RunZoneHeadlineMediumLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneHeadlineSmallLabel, path: '[Design System]/Label')
Widget buildHeadlineSmallLabelUseCase(BuildContext context) {
  return RunZoneHeadlineSmallLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneTitleLargeLabel, path: '[Design System]/Label')
Widget buildTitleLargeLabelUseCase(BuildContext context) {
  return RunZoneTitleLargeLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneTitleMediumLabel, path: '[Design System]/Label')
Widget buildTitleMediumLabelUseCase(BuildContext context) {
  return RunZoneTitleMediumLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneTitleSmallLabel, path: '[Design System]/Label')
Widget buildTitleSmallLabelUseCase(BuildContext context) {
  return RunZoneTitleSmallLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneBodyLargeLabel, path: '[Design System]/Label')
Widget buildBodyLargeLabelUseCase(BuildContext context) {
  return RunZoneBodyLargeLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneBodyMediumLabel, path: '[Design System]/Label')
Widget buildBodyMediumLabelUseCase(BuildContext context) {
  return RunZoneBodyMediumLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneBodySmallLabel, path: '[Design System]/Label')
Widget buildBodySmallLabelUseCase(BuildContext context) {
  return RunZoneBodySmallLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneLabelLargeLabel, path: '[Design System]/Label')
Widget buildLabelLargeLabelUseCase(BuildContext context) {
  return RunZoneLabelLargeLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneLabelMediumLabel, path: '[Design System]/Label')
Widget buildLabelMediumLabelUseCase(BuildContext context) {
  return RunZoneLabelMediumLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}

@widgetbook.UseCase(name: 'Default', type: RunZoneLabelSmallLabel, path: '[Design System]/Label')
Widget buildLabelSmallLabelUseCase(BuildContext context) {
  return RunZoneLabelSmallLabel(context.knobs.string(label: 'Text', initialValue: _defaultText));
}
