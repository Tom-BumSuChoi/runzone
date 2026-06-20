import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_radius.dart';
import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/assets/run_zone_icon_asset.dart';
import '../../../../../core/design_system/widgets/button/run_zone_icon_outline_button.dart';
import '../../../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../../../core/design_system/widgets/label/run_zone_body_small_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_title_large_label.dart';

final class WorkoutTreadmillPanel extends StatelessWidget {
  const WorkoutTreadmillPanel({
    required this.speed,
    required this.isManualMode,
    required this.statusLabel,
    required this.onDecrease,
    required this.onIncrease,
    required this.onResetAutomaticMode,
    super.key,
  });

  final double speed;
  final bool isManualMode;
  final String statusLabel;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onResetAutomaticMode;

  @override
  Widget build(BuildContext context) {
    return RunZoneCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const RunZoneLabelSmallLabel('러닝머신'),
              _WorkoutTreadmillStatusBadge(
                isManualMode: isManualMode,
                statusLabel: statusLabel,
                onResetAutomaticMode: onResetAutomaticMode,
              ),
            ],
          ),
          AppSpacing.controlGroupSpacer,
          _WorkoutTreadmillSpeedControl(speed: speed, onDecrease: onDecrease, onIncrease: onIncrease),
        ],
      ),
    );
  }
}

final class _WorkoutTreadmillStatusBadge extends StatelessWidget {
  const _WorkoutTreadmillStatusBadge({
    required this.isManualMode,
    required this.statusLabel,
    required this.onResetAutomaticMode,
  });

  final bool isManualMode;
  final String statusLabel;
  final VoidCallback onResetAutomaticMode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = isManualMode ? colorScheme.outline : colorScheme.primary;
    final borderRadius = isManualMode ? AppRadius.pillBorder : AppRadius.badgeBorder;
    final content = isManualMode
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RunZoneLabelSmallLabel(statusLabel, color: colorScheme.onSurfaceVariant),
              AppSpacing.inlineLabelGap,
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: colorScheme.primary)),
                ),
                child: RunZoneLabelSmallLabel('다시 자동', color: colorScheme.primary),
              ),
            ],
          )
        : RunZoneLabelSmallLabel(statusLabel, color: colorScheme.primary);

    final pill = DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: borderRadius,
      ),
      child: Padding(padding: AppSpacing.badgeInsets, child: content),
    );

    return isManualMode
        ? GestureDetector(behavior: HitTestBehavior.opaque, onTap: onResetAutomaticMode, child: pill)
        : pill;
  }
}

final class _WorkoutTreadmillSpeedControl extends StatelessWidget {
  const _WorkoutTreadmillSpeedControl({required this.speed, required this.onDecrease, required this.onIncrease});

  final double speed;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RunZoneBodySmallLabel('속도 km/h'),
        const SizedBox(height: AppSpacing.controlLabelGap),
        Row(
          children: [
            RunZoneIconOutlineButton(icon: RunZoneIconAsset.minus, onPressed: onDecrease),
            Expanded(child: Center(child: RunZoneTitleLargeLabel(speed.toStringAsFixed(1)))),
            RunZoneIconOutlineButton(icon: RunZoneIconAsset.plus, onPressed: onIncrease),
          ],
        ),
      ],
    );
  }
}
