import 'package:flutter/material.dart';

import '../../app_sizing.dart';
import '../../app_spacing.dart';
import 'run_zone_bottom_navigation_slot.dart';

export 'run_zone_bottom_navigation_item.dart';
export 'run_zone_bottom_navigation_slot.dart';
export 'run_zone_bottom_navigation_start_button.dart';

final class RunZoneBottomNavigation extends StatelessWidget {
  const RunZoneBottomNavigation({super.key, required this.items});

  final List<RunZoneBottomNavigationSlot> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline)),
      ),
      child: SizedBox(
        height: AppSizing.navigationHeight,
        child: Padding(
          padding: AppSpacing.navigationInsets,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [for (final item in items) Expanded(child: item)],
          ),
        ),
      ),
    );
  }
}
