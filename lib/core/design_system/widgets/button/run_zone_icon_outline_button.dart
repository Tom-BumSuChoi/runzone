import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_radius.dart';
import '../../app_sizing.dart';
import '../../assets/run_zone_icon_asset.dart';

final class RunZoneIconOutlineButton extends StatelessWidget {
  const RunZoneIconOutlineButton({
    required this.icon,
    required this.onPressed,
    this.foregroundColor,
    this.borderColor,
    super.key,
  });

  final RunZoneIconAsset icon;
  final VoidCallback onPressed;
  final Color? foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
    final effectiveBorderColor = borderColor ?? colorScheme.outline;

    return SizedBox.square(
      dimension: AppSizing.iconOutlineButtonSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: effectiveBorderColor),
          borderRadius: AppRadius.smallBorder,
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            icon.path,
            width: AppSizing.iconOutlineButtonIconSize,
            height: AppSizing.iconOutlineButtonIconSize,
            colorFilter: ColorFilter.mode(effectiveForegroundColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
