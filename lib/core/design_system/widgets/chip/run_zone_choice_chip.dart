import 'package:flutter/material.dart';

final class RunZoneChoiceChip extends StatelessWidget {
  const RunZoneChoiceChip({super.key, required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chipTheme = Theme.of(context).chipTheme;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      side: BorderSide(color: isSelected ? Colors.transparent : colorScheme.outlineVariant),
      labelStyle: isSelected ? chipTheme.secondaryLabelStyle : chipTheme.labelStyle,
    );
  }
}
