import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_sizing.dart';
import '../../assets/run_zone_icon_asset.dart';
import '../label/run_zone_label_large_label.dart';

final class RunZonePrimaryButton extends StatelessWidget {
  const RunZonePrimaryButton({required this.label, required this.onPressed, this.icon, super.key});

  final String label;
  final VoidCallback? onPressed;
  final RunZoneIconAsset? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = onPressed != null;
    final foregroundColor = isEnabled ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;
    final icon = this.icon;

    final labelWidget = RunZoneLabelLargeLabel(label, color: foregroundColor);

    return SizedBox(
      width: double.infinity,
      child: icon == null
          ? FilledButton(onPressed: onPressed, child: labelWidget)
          : FilledButton.icon(
              onPressed: onPressed,
              icon: SvgPicture.asset(
                icon.path,
                width: AppSizing.buttonIconSize,
                height: AppSizing.buttonIconSize,
                colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
              ),
              label: labelWidget,
            ),
    );
  }
}
