import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_radius.dart';
import '../../app_sizing.dart';
import '../../app_spacing.dart';
import '../../assets/run_zone_icon_asset.dart';
import 'run_zone_bottom_navigation_slot.dart';

final class RunZoneBottomNavigationStartButton extends RunZoneBottomNavigationSlot {
  const RunZoneBottomNavigationStartButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: onTap,
        child: Transform.translate(
          offset: const Offset(0, -AppSpacing.navigationStartButtonLift),
          child: Container(
            width: AppSizing.navigationStartButtonSize,
            height: AppSizing.navigationStartButtonSize,
            decoration: BoxDecoration(color: colorScheme.primary, borderRadius: AppRadius.mediumBorder),
            child: Center(
              child: SvgPicture.asset(
                RunZoneIconAsset.play.path,
                width: AppSizing.navigationIconSize,
                height: AppSizing.navigationIconSize,
                colorFilter: ColorFilter.mode(colorScheme.onPrimary, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
