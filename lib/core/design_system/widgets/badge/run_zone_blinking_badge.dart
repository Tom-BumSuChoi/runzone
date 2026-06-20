import 'package:flutter/material.dart';

import '../../app_radius.dart';
import '../../app_sizing.dart';
import '../../app_spacing.dart';
import '../label/run_zone_label_medium_label.dart';

final class RunZoneBlinkingBadge extends StatefulWidget {
  const RunZoneBlinkingBadge({required this.label, required this.color, super.key});

  final String label;
  final Color color;

  @override
  State<RunZoneBlinkingBadge> createState() => _RunZoneBlinkingBadgeState();
}

final class _RunZoneBlinkingBadgeState extends State<RunZoneBlinkingBadge> with SingleTickerProviderStateMixin {
  static const _blinkDuration = Duration(milliseconds: 1000);
  static const _visibleOpacity = 1.0;
  static const _dimmedOpacity = 0.25;
  static const _blinkThreshold = 0.5;

  late final AnimationController _animationController = AnimationController(vsync: this, duration: _blinkDuration)
    ..repeat(reverse: true);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: widget.color),
        borderRadius: AppRadius.badgeBorder,
      ),
      child: Padding(
        padding: AppSpacing.badgeInsets,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (_, child) {
                final opacity = _animationController.value < _blinkThreshold ? _visibleOpacity : _dimmedOpacity;
                return Opacity(opacity: opacity, child: child);
              },
              child: DecoratedBox(
                decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
                child: const SizedBox.square(dimension: AppSizing.connectionIndicatorSize),
              ),
            ),
            AppSpacing.inlineLabelGap,
            RunZoneLabelMediumLabel(widget.label, color: widget.color),
          ],
        ),
      ),
    );
  }
}
