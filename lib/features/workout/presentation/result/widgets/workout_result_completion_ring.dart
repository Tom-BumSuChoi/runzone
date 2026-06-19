import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/design_system/app_sizing.dart';
import '../../../../../core/design_system/assets/run_zone_icon_asset.dart';

final class WorkoutResultCompletionRing extends StatelessWidget {
  const WorkoutResultCompletionRing({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: AppSizing.completionRingSize,
      height: AppSizing.completionRingSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary.withValues(alpha: 0.2),
        border: Border.all(color: colorScheme.primary, width: AppSizing.completionRingBorderWidth),
      ),
      child: SvgPicture.asset(
        RunZoneIconAsset.check.path,
        width: AppSizing.completionRingIconSize,
        height: AppSizing.completionRingIconSize,
        colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
      ),
    );
  }
}
