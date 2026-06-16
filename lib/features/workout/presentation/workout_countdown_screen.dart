import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/label/run_zone_display_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_display_medium_label.dart';

final class WorkoutCountdownScreen extends StatefulWidget {
  const WorkoutCountdownScreen({super.key});

  @override
  State<WorkoutCountdownScreen> createState() => _WorkoutCountdownScreenState();
}

final class _WorkoutCountdownScreenState extends State<WorkoutCountdownScreen> {
  static const _initialCount = 3;
  static const _stepDuration = Duration(seconds: 1);

  Timer? _timer;
  int _count = _initialCount;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_stepDuration, _onTick);
  }

  void _onTick(Timer timer) {
    if (_count == 0) {
      timer.cancel();
      if (!mounted) {
        return;
      }

      context.go(AppRoutes.workoutLive);
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() => _count--);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = _count > 0 ? '준비' : '출발';
    final countText = _count > 0 ? '$_count' : 'GO';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              key: ValueKey(countText),
              tween: Tween(begin: 0.5, end: 1.5),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: RunZoneDisplayLargeLabel(countText, color: colorScheme.primary),
            ),
            AppSpacing.headerTitleGap,
            RunZoneDisplayMediumLabel(label, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
