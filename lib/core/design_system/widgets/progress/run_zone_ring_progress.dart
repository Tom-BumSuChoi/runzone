import 'dart:math' as math;

import 'package:flutter/material.dart';

final class RunZoneRingProgress extends StatefulWidget {
  const RunZoneRingProgress({
    required this.value,
    required this.color,
    required this.child,
    required this.size,
    super.key,
  });

  final double value;
  final Color color;
  final Widget child;
  final double size;

  @override
  State<RunZoneRingProgress> createState() => _RunZoneRingProgressState();
}

final class _RunZoneRingProgressState extends State<RunZoneRingProgress> with SingleTickerProviderStateMixin {
  static const _strokeWidth = 10.0;
  static const _shadowBlur = 5.0;
  static const _ringInset = _strokeWidth / 2 + _shadowBlur;
  static const _pulseDuration = Duration(milliseconds: 1000);
  static const _pulseRestScale = 1.0;
  static const _ringPulseScaleDelta = 0.02;
  static const _ringPulseScale = _pulseRestScale + _ringPulseScaleDelta;
  static const _pulseGrowPhase = 5.0;
  static const _pulseShrinkPhase = 5.0;

  late final AnimationController _animationController = AnimationController(vsync: this, duration: _pulseDuration);

  late final Animation<double> _ringScale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: _pulseRestScale, end: _ringPulseScale).chain(CurveTween(curve: Curves.easeInOut)),
      weight: _pulseGrowPhase,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: _ringPulseScale, end: _pulseRestScale).chain(CurveTween(curve: Curves.easeInOut)),
      weight: _pulseShrinkPhase,
    ),
  ]).animate(_animationController);

  @override
  void initState() {
    super.initState();
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ring = CustomPaint(
      size: Size.square(widget.size),
      painter: _RunZoneRingProgressPainter(
        progress: widget.value,
        color: widget.color,
        backgroundColor: colorScheme.outline,
        strokeWidth: _strokeWidth,
        ringInset: _ringInset,
        shadowBlur: _shadowBlur,
      ),
    );

    return SizedBox.square(
      dimension: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ScaleTransition(scale: _ringScale, child: ring),
          widget.child,
        ],
      ),
    );
  }
}

final class _RunZoneRingProgressPainter extends CustomPainter {
  const _RunZoneRingProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.ringInset,
    required this.shadowBlur,
  });

  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;
  final double ringInset;
  final double shadowBlur;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - ringInset;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = -math.pi / 2;
    final clampedProgress = progress.clamp(0.0, 1.0).toDouble();
    final sweepAngle = math.pi * 2 * clampedProgress;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final shadowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, shadowPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _RunZoneRingProgressPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor ||
        strokeWidth != oldDelegate.strokeWidth ||
        ringInset != oldDelegate.ringInset ||
        shadowBlur != oldDelegate.shadowBlur;
  }
}
