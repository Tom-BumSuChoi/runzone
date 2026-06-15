import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_sizing.dart';
import '../label/run_zone_body_small_label.dart';

final class RunZoneInlineActionButton extends StatelessWidget {
  const RunZoneInlineActionButton({required this.iconAsset, required this.label, required this.onPressed, super.key});

  final String iconAsset;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton.icon(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        iconAsset,
        width: AppSizing.inlineIconSize,
        height: AppSizing.inlineIconSize,
        colorFilter: ColorFilter.mode(colorScheme.onSurfaceVariant, BlendMode.srcIn),
      ),
      label: RunZoneBodySmallLabel(label),
    );
  }
}
