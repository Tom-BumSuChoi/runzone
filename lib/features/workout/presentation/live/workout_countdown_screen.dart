import 'package:flutter/material.dart';

import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/label/run_zone_display_large_label.dart';
import '../../../../core/design_system/widgets/label/run_zone_display_medium_label.dart';
import 'bloc/workout_live_bloc.dart';

final class WorkoutCountdownScreen extends StatelessWidget {
  const WorkoutCountdownScreen({required this.state, super.key});

  final WorkoutLiveCountingDown state;

  static const List<String> _countTexts = ['3', '2', '1', 'GO'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final countText = _countTexts[state.countIndex];
    final label = countText == 'GO' ? '출발' : '준비';

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
              builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
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
