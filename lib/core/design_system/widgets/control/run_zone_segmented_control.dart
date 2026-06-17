import 'package:flutter/material.dart';

import '../../app_radius.dart';
import '../../app_spacing.dart';
import '../label/run_zone_label_medium_label.dart';

final class RunZoneSegmentedControl<T> extends StatelessWidget {
  const RunZoneSegmentedControl({
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });

  final List<RunZoneSegmentedControlOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: AppRadius.smallBorder),
      child: Padding(
        padding: AppSpacing.segmentedControlInsets,
        child: Row(
          spacing: AppSpacing.segmentedControlGap,
          children: [
            for (final option in options)
              _RunZoneSegmentedControlButton<T>(
                option: option,
                isSelected: option.value == selectedValue,
                onChanged: onChanged,
              ),
          ],
        ),
      ),
    );
  }
}

final class RunZoneSegmentedControlOption<T> {
  const RunZoneSegmentedControlOption({required this.value, required this.label});

  final T value;
  final String label;
}

final class _RunZoneSegmentedControlButton<T> extends StatelessWidget {
  const _RunZoneSegmentedControlButton({required this.option, required this.isSelected, required this.onChanged});

  final RunZoneSegmentedControlOption<T> option;
  final bool isSelected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Semantics(
        selected: isSelected,
        child: TextButton(
          onPressed: () => onChanged(option.value),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(isSelected ? colorScheme.primary : Colors.transparent),
            padding: const WidgetStatePropertyAll(AppSpacing.segmentedControlButtonInsets),
            shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: AppRadius.badgeBorder)),
          ),
          child: RunZoneLabelMediumLabel(
            option.label,
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
