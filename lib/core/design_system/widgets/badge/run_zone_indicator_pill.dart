import 'package:flutter/material.dart';

import '../../app_radius.dart';
import '../../app_sizing.dart';
import '../../app_spacing.dart';
import '../label/run_zone_label_medium_label.dart';

final class RunZoneIndicatorPill extends StatefulWidget {
  const RunZoneIndicatorPill({required this.label, required this.color, super.key});

  final String label;
  final Color color;

  @override
  State<RunZoneIndicatorPill> createState() => _RunZoneIndicatorPillState();
}

final class _RunZoneIndicatorPillState extends State<RunZoneIndicatorPill> with SingleTickerProviderStateMixin {
  static const _heartbeatDuration = Duration(milliseconds: 1000);
  static const _heartbeatRestScale = 1.0;
  static const _heartbeatPeakScale = 1.5;
  static const _heartbeatGrowPhase = 4.0;
  static const _heartbeatShrinkPhase = 6.0;

  late final AnimationController _animationController = AnimationController(vsync: this, duration: _heartbeatDuration)
    ..repeat();

  late final Animation<double> _indicatorScale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(
        begin: _heartbeatRestScale,
        end: _heartbeatPeakScale,
      ).chain(CurveTween(curve: Curves.easeInOut)),
      weight: _heartbeatGrowPhase,
    ),
    TweenSequenceItem(
      tween: Tween<double>(
        begin: _heartbeatPeakScale,
        end: _heartbeatRestScale,
      ).chain(CurveTween(curve: Curves.easeInOut)),
      weight: _heartbeatShrinkPhase,
    ),
  ]).animate(_animationController);

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
        borderRadius: AppRadius.pillBorder,
      ),
      child: Padding(
        padding: AppSpacing.badgeInsets,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _indicatorScale,
              child: DecoratedBox(
                decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
                child: const SizedBox.square(dimension: AppSizing.indicatorSize),
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
