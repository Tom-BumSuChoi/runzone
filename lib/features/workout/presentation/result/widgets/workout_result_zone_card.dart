import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_color_scheme.dart';
import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/widgets/bar/segmented_bar.dart';
import '../../../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../../../core/design_system/widgets/label/run_zone_body_small_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_title_small_label.dart';
import '../../../../heart_rate/domain/heart_rate_zone.dart';
import '../../../../heart_rate/presentation/heart_rate_zone_display.dart';

final class WorkoutResultZoneCard extends StatelessWidget {
  const WorkoutResultZoneCard({
    required this.zoneProportions,
    required this.dominantZone,
    required this.dominantZonePercent,
    super.key,
  });

  final Map<HeartRateZone, double> zoneProportions;
  final HeartRateZone? dominantZone;
  final int dominantZonePercent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final maxProportion = zoneProportions.values.fold<double>(0, (accumulator, proportion) {
      return proportion > accumulator ? proportion : accumulator;
    });
    final dominantZone = this.dominantZone;
    final summary = dominantZone == null ? '--' : '${dominantZone.shortLabel} · $dominantZonePercent%';

    return RunZoneCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const RunZoneLabelSmallLabel('심박존 시간'),
              RunZoneTitleSmallLabel(summary, color: colorScheme.valueEmphasis),
            ],
          ),
          AppSpacing.sectionLabelGap,
          RunZoneSegmentedBar(
            segments: [
              for (final zone in HeartRateZone.values)
                RunZoneSegmentData(
                  label: zone.shortLabel,
                  color: zone.color(colorScheme),
                  heightFactor: maxProportion == 0 ? 0 : (zoneProportions[zone] ?? 0) / maxProportion,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
