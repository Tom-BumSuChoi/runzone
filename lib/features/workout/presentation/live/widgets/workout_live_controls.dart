import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/design_system/app_radius.dart';
import '../../../../../core/design_system/app_sizing.dart';
import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/assets/run_zone_icon_asset.dart';

final class WorkoutLiveControls extends StatelessWidget {
  const WorkoutLiveControls({required this.onLap, required this.onPause, required this.onStop, super.key});

  final VoidCallback onLap;
  final VoidCallback onPause;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outline)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.controlBarPadding),
        child: Row(
          spacing: AppSpacing.controlGroupGap,
          children: [
            Expanded(
              child: _WorkoutLiveControlButton(
                icon: RunZoneIconAsset.lap,
                semanticLabel: '랩',
                foregroundColor: colorScheme.onSurface,
                borderColor: colorScheme.outline,
                onPressed: onLap,
              ),
            ),
            Semantics(
              label: '일시정지',
              button: true,
              onTap: onPause,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onPause,
                child: SizedBox.square(
                  dimension: AppSizing.workoutLiveControlButtonSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                    child: Center(
                      child: SvgPicture.asset(
                        RunZoneIconAsset.pause.path,
                        width: AppSizing.workoutLivePrimaryIconSize,
                        height: AppSizing.workoutLivePrimaryIconSize,
                        colorFilter: ColorFilter.mode(colorScheme.onPrimary, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _WorkoutLiveControlButton(
                icon: RunZoneIconAsset.stop,
                semanticLabel: '종료',
                foregroundColor: colorScheme.error,
                borderColor: colorScheme.error,
                onPressed: onStop,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _WorkoutLiveControlButton extends StatelessWidget {
  const _WorkoutLiveControlButton({
    required this.icon,
    required this.semanticLabel,
    required this.foregroundColor,
    required this.borderColor,
    required this.onPressed,
  });

  final RunZoneIconAsset icon;
  final String semanticLabel;
  final Color foregroundColor;
  final Color borderColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      onTap: onPressed,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: AppRadius.mediumBorder,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.controlBarPadding),
            child: Center(
              child: SvgPicture.asset(
                icon.path,
                width: AppSizing.navigationIconSize,
                height: AppSizing.navigationIconSize,
                colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
