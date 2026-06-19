import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/design_system/app_sizing.dart';
import '../../../../../core/design_system/assets/run_zone_icon_asset.dart';

final class WorkoutPausedIconRing extends StatelessWidget {
  const WorkoutPausedIconRing({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: AppSizing.pausedIconRingSize,
      height: AppSizing.pausedIconRingSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Center(
        child: SvgPicture.asset(
          RunZoneIconAsset.pause.path,
          width: AppSizing.pausedIconSize,
          height: AppSizing.pausedIconSize,
          colorFilter: ColorFilter.mode(colorScheme.onSurfaceVariant, BlendMode.srcIn),
        ),
      ),
    );
  }
}
