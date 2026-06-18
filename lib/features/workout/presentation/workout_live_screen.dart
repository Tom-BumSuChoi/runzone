import 'package:flutter/material.dart';

import '../../../core/design_system/app_color_scheme.dart';
import '../../../core/design_system/app_radius.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/badge/run_zone_blinking_badge.dart';
import '../../../core/design_system/widgets/badge/run_zone_indicator_pill.dart';
import '../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../core/design_system/widgets/chart/run_zone_sparkline.dart';
import '../../../core/design_system/widgets/label/run_zone_body_small_label.dart';
import '../../../core/design_system/widgets/label/run_zone_display_small_label.dart';
import '../../../core/design_system/widgets/label/run_zone_label_medium_label.dart';
import '../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../core/design_system/widgets/label/run_zone_title_large_label.dart';
import '../../../core/design_system/widgets/progress/run_zone_ring_progress.dart';
import 'widgets/workout_live_controls.dart';

final class WorkoutLiveScreen extends StatelessWidget {
  const WorkoutLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: AppSpacing.screenInsets,
                child: Column(
                  children: [
                    const _WorkoutLiveHeader(),
                    AppSpacing.headerTitleGap,
                    _WorkoutHeartRatePanel(colorScheme: colorScheme),
                    AppSpacing.sectionGap,
                    const _WorkoutTreadmillPanel(),
                    AppSpacing.sectionGap,
                    const _WorkoutHeartRateTrendPanel(),
                    AppSpacing.sectionGap,
                    const _WorkoutMetricRow(),
                  ],
                ),
              ),
            ),
          ),
          WorkoutLiveControls(onLap: () {}, onPause: () {}, onStop: () {}),
        ],
      ),
    );
  }
}

final class _WorkoutLiveHeader extends StatelessWidget {
  const _WorkoutLiveHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final zoneColor = colorScheme.zoneTwo;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RunZoneIndicatorPill(label: 'Z2 유지 중', color: zoneColor),
        RunZoneBlinkingBadge(label: '연결됨', color: colorScheme.error),
      ],
    );
  }
}

final class _WorkoutHeartRatePanel extends StatelessWidget {
  const _WorkoutHeartRatePanel({required this.colorScheme});

  static const _beatsPerMinute = 144;
  static const _heartRateMinimum = 90;
  static const _heartRateMaximum = 186;
  static const _readoutFontSizeFactor = 0.34;
  static const _ringSize = 214.0;

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final zoneColor = colorScheme.zoneTwo;
    const progress = (_beatsPerMinute - _heartRateMinimum) / (_heartRateMaximum - _heartRateMinimum);

    return RunZoneRingProgress(
      value: progress,
      color: zoneColor,
      size: _ringSize,
      child: _WorkoutHeartRateReadout(
        color: zoneColor,
        beatsPerMinute: _beatsPerMinute,
        valueFontSize: _ringSize * _readoutFontSizeFactor,
      ),
    );
  }
}

final class _WorkoutHeartRateReadout extends StatelessWidget {
  const _WorkoutHeartRateReadout({required this.color, required this.beatsPerMinute, required this.valueFontSize});

  final Color color;
  final int beatsPerMinute;
  final double valueFontSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RunZoneLabelSmallLabel('Z2 · 지구력', color: color),
        Text(
          '$beatsPerMinute',
          style: textTheme.displayLarge?.copyWith(color: color, fontSize: valueFontSize),
        ),
        RunZoneLabelMediumLabel('bpm', color: colorScheme.onSurfaceVariant),
        const SizedBox(height: AppSpacing.controlLabelGap),
        RunZoneLabelSmallLabel('목표 132–148', color: colorScheme.onSurfaceVariant),
      ],
    );
  }
}

final class _WorkoutTreadmillPanel extends StatefulWidget {
  const _WorkoutTreadmillPanel();

  @override
  State<_WorkoutTreadmillPanel> createState() => _WorkoutTreadmillPanelState();
}

final class _WorkoutTreadmillPanelState extends State<_WorkoutTreadmillPanel> {
  static const _automaticSpeed = 9.8;
  static const _speedStep = 0.1;
  static const _minimumSpeed = 0.0;
  static const _maximumSpeed = 25.0;

  bool _isManualMode = false;
  double? _manualSpeed;

  double get _displaySpeed => _manualSpeed ?? _automaticSpeed;

  void _adjustSpeed(double delta) {
    setState(() {
      final nextSpeed = (_displaySpeed + delta).clamp(_minimumSpeed, _maximumSpeed);
      _manualSpeed = (nextSpeed * 10).round() / 10;
      _isManualMode = true;
    });
  }

  void _resetAutomaticMode() {
    setState(() {
      _isManualMode = false;
      _manualSpeed = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RunZoneCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const RunZoneLabelSmallLabel('러닝머신'),
              if (_isManualMode)
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: AppRadius.pillBorder,
                  ),
                  child: Padding(
                    padding: AppSpacing.badgeInsets,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RunZoneLabelSmallLabel('MANUAL · 사용자 조작', color: colorScheme.onSurfaceVariant),
                        AppSpacing.inlineLabelGap,
                        GestureDetector(
                          onTap: _resetAutomaticMode,
                          child: RunZoneLabelSmallLabel('다시 자동', color: colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                RunZoneLabelSmallLabel('AUTO · 속도 유지', color: colorScheme.primary),
            ],
          ),
          AppSpacing.controlGroupSpacer,
          Center(
            child: Column(
              children: [
                const RunZoneBodySmallLabel('속도 km/h', textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.controlLabelGap),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _WorkoutTreadmillSpeedButton(icon: Icons.remove, onPressed: () => _adjustSpeed(-_speedStep)),
                    const SizedBox(width: AppSpacing.controlGroupGap),
                    RunZoneTitleLargeLabel(_displaySpeed.toStringAsFixed(1)),
                    const SizedBox(width: AppSpacing.controlGroupGap),
                    _WorkoutTreadmillSpeedButton(icon: Icons.add, onPressed: () => _adjustSpeed(_speedStep)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _WorkoutTreadmillSpeedButton extends StatelessWidget {
  const _WorkoutTreadmillSpeedButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: 42,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline),
          borderRadius: AppRadius.mediumBorder,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          color: colorScheme.onSurface,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

final class _WorkoutHeartRateTrendPanel extends StatelessWidget {
  const _WorkoutHeartRateTrendPanel();

  static const _heartRateValues = <double>[132, 136, 139, 142, 144, 143, 145, 144];
  static const _heartRateMinimum = 96.0;
  static const _heartRateMaximum = 182.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RunZoneCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const RunZoneLabelSmallLabel('심박 추이'), const RunZoneLabelSmallLabel('최근 40초')],
          ),
          AppSpacing.controlGroupSpacer,
          RunZoneSparkline(
            values: _heartRateValues,
            minimum: _heartRateMinimum,
            maximum: _heartRateMaximum,
            color: colorScheme.zoneTwo,
          ),
        ],
      ),
    );
  }
}

final class _WorkoutMetricRow extends StatelessWidget {
  const _WorkoutMetricRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _WorkoutMetric(value: '0:00', label: '경과'),
        ),
        SizedBox(width: AppSpacing.chipGap),
        Expanded(
          child: _WorkoutMetric(value: '40:00', label: '남음'),
        ),
        SizedBox(width: AppSpacing.chipGap),
        Expanded(
          child: _WorkoutMetric(value: '0.00', label: 'km'),
        ),
      ],
    );
  }
}

final class _WorkoutMetric extends StatelessWidget {
  const _WorkoutMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RunZoneDisplaySmallLabel(value, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.controlLabelGap),
        RunZoneLabelSmallLabel(label, textAlign: TextAlign.center),
      ],
    );
  }
}
