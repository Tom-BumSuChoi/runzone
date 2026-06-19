import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/widgets/label/run_zone_display_large_label.dart';
import '../../../../../core/design_system/widgets/label/run_zone_display_medium_label.dart';

final class WorkoutCountdown extends StatefulWidget {
  const WorkoutCountdown({required this.onCompleted, super.key});

  final VoidCallback onCompleted;

  @override
  State<WorkoutCountdown> createState() => _WorkoutCountdownState();
}

final class _WorkoutCountdownState extends State<WorkoutCountdown> {
  static const List<String> _countTexts = ['3', '2', '1', 'GO'];

  Timer? _timer;
  int _countIndex = 0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_countIndex < _countTexts.length - 1) {
      setState(() => _countIndex += 1);
      return;
    }

    if (_isCompleted) {
      return;
    }

    _isCompleted = true;
    _timer?.cancel();
    _timer = null;
    widget.onCompleted();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final countText = _countTexts[_countIndex];
    final label = countText == 'GO' ? '출발' : '준비';

    return Center(
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
    );
  }
}
