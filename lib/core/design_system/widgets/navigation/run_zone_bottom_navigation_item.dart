import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_sizing.dart';
import '../../app_spacing.dart';
import '../../assets/run_zone_icon_asset.dart';
import '../label/run_zone_label_small_label.dart';
import 'run_zone_bottom_navigation_slot.dart';

final class RunZoneBottomNavigationItem extends RunZoneBottomNavigationSlot {
  const RunZoneBottomNavigationItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final RunZoneIconAsset icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon.path,
            width: AppSizing.navigationIconSize,
            height: AppSizing.navigationIconSize,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          AppSpacing.navigationLabelGap,
          RunZoneLabelSmallLabel(label, color: color),
        ],
      ),
    );
  }
}
