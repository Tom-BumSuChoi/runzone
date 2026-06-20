import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_radius.dart';
import '../../app_sizing.dart';
import '../../app_spacing.dart';
import '../../assets/run_zone_icon_asset.dart';
import '../label/run_zone_label_large_label.dart';

final class RunZoneDangerButton extends StatelessWidget {
  const RunZoneDangerButton({required this.label, required this.onPressed, this.icon, super.key});

  final String label;
  final VoidCallback? onPressed;
  final RunZoneIconAsset? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = this.icon;
    final dangerColor = colorScheme.error;

    final style = OutlinedButton.styleFrom(
      backgroundColor: colorScheme.surfaceContainerHighest,
      foregroundColor: dangerColor,
      minimumSize: const Size(AppSizing.touchTarget, AppSizing.touchTarget),
      padding: AppSpacing.buttonInsets,
      side: BorderSide(color: dangerColor),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.smallBorder),
    );

    final labelWidget = RunZoneLabelLargeLabel(label, color: dangerColor);

    return SizedBox(
      width: double.infinity,
      child: icon == null
          ? OutlinedButton(onPressed: onPressed, style: style, child: labelWidget)
          : OutlinedButton.icon(
              onPressed: onPressed,
              style: style,
              icon: SvgPicture.asset(
                icon.path,
                width: AppSizing.buttonIconSize,
                height: AppSizing.buttonIconSize,
                colorFilter: ColorFilter.mode(dangerColor, BlendMode.srcIn),
              ),
              label: labelWidget,
            ),
    );
  }
}
