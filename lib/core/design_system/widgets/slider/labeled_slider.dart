import 'package:flutter/material.dart';

import '../../app_spacing.dart';
import '../swatch/color_swatch.dart';
import '../label/run_zone_caption_label.dart';
import '../label/run_zone_emphasis_label.dart';

final class RunZoneLabeledSlider extends StatelessWidget {
  const RunZoneLabeledSlider({
    required this.label,
    required this.valueLabel,
    required this.unitLabel,
    required this.value,
    required this.minimum,
    required this.maximum,
    required this.leadingColor,
    required this.trailingColor,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String valueLabel;
  final String unitLabel;
  final double value;
  final double minimum;
  final double maximum;
  final Color leadingColor;
  final Color trailingColor;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.controlLabelGap,
      children: [
        _RunZoneLabeledSliderHeader(
          label: label,
          valueLabel: valueLabel,
          unitLabel: unitLabel,
          leadingColor: leadingColor,
          trailingColor: trailingColor,
        ),
        Slider(min: minimum, max: maximum, value: value.clamp(minimum, maximum).toDouble(), onChanged: onChanged),
      ],
    );
  }
}

final class _RunZoneLabeledSliderHeader extends StatelessWidget {
  const _RunZoneLabeledSliderHeader({
    required this.label,
    required this.valueLabel,
    required this.unitLabel,
    required this.leadingColor,
    required this.trailingColor,
  });

  final String label;
  final String valueLabel;
  final String unitLabel;
  final Color leadingColor;
  final Color trailingColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        RunZoneColorSwatch(color: leadingColor),
        AppSpacing.inlineLabelGap,
        RunZoneCaptionLabel(label),
        AppSpacing.inlineLabelGap,
        RunZoneColorSwatch(color: trailingColor),
        const Spacer(),
        RunZoneEmphasisLabel(valueLabel),
        AppSpacing.inlineValueGap,
        RunZoneCaptionLabel(unitLabel, color: colorScheme.onSurfaceVariant),
      ],
    );
  }
}
