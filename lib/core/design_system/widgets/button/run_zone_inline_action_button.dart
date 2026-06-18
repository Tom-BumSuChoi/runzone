import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_sizing.dart';
import '../../assets/run_zone_icon_asset.dart';
import '../label/run_zone_body_small_label.dart';

final class RunZoneInlineActionButton extends StatelessWidget {
  const RunZoneInlineActionButton({required this.icon, required this.label, required this.onPressed, super.key});

  final RunZoneIconAsset icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton.icon(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        icon.path,
        width: AppSizing.inlineIconSize,
        height: AppSizing.inlineIconSize,
        colorFilter: ColorFilter.mode(colorScheme.onSurfaceVariant, BlendMode.srcIn),
      ),
      label: RunZoneBodySmallLabel(label),
    );
  }
}
