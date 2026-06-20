import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_radius.dart';
import '../../app_sizing.dart';
import '../../app_spacing.dart';
import '../../assets/run_zone_icon_asset.dart';
import '../label/run_zone_body_small_label.dart';
import '../label/run_zone_headline_small_label.dart';
import 'run_zone_card.dart';

final class RunZoneActionCard extends StatelessWidget {
  const RunZoneActionCard({required this.icon, required this.title, required this.subtitle, super.key});

  final RunZoneIconAsset icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RunZoneCard(
      child: Row(
        children: [
          Container(
            width: AppSizing.iconOutlineButtonSize,
            height: AppSizing.iconOutlineButtonSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: AppRadius.smallBorder),
            child: SvgPicture.asset(
              icon.path,
              width: AppSizing.buttonIconSize,
              height: AppSizing.buttonIconSize,
              colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
            ),
          ),
          AppSpacing.inlineLabelGap,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RunZoneHeadlineSmallLabel(title),
                RunZoneBodySmallLabel(subtitle, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
          SvgPicture.asset(
            RunZoneIconAsset.chevronRight.path,
            width: AppSizing.buttonIconSize,
            height: AppSizing.buttonIconSize,
            colorFilter: ColorFilter.mode(colorScheme.onSurfaceVariant, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}
