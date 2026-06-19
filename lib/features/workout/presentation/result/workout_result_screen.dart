import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/assets/run_zone_icon_asset.dart';
import '../../../../core/design_system/widgets/button/run_zone_primary_button.dart';
import '../../../../core/design_system/widgets/card/run_zone_action_card.dart';
import '../../../../core/design_system/widgets/label/run_zone_headline_medium_label.dart';
import '../../../../core/design_system/widgets/label/run_zone_label_medium_label.dart';
import 'workout_result_cubit.dart';
import 'widgets/workout_result_completion_ring.dart';
import 'widgets/workout_result_metrics_card.dart';
import 'widgets/workout_result_zone_card.dart';

final class WorkoutResultScreen extends StatelessWidget {
  const WorkoutResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<WorkoutResultCubit, WorkoutResultState>(
          builder: (context, state) {
            return Padding(
              padding: AppSpacing.screenInsets,
              child: Column(
                children: [
                  const WorkoutResultCompletionRing(),
                  AppSpacing.controlGroupSpacer,
                  const RunZoneHeadlineMediumLabel('잘 달렸어요!', textAlign: TextAlign.center),
                  AppSpacing.titleDescriptionGap,
                  RunZoneLabelMediumLabel(
                    state.subtitle,
                    color: colorScheme.onSurfaceVariant,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.headerTitleGap,
                  WorkoutResultMetricsCard(
                    distanceKm: state.distanceKm,
                    durationLabel: state.durationLabel,
                    averageBpm: state.averageBpm,
                  ),
                  AppSpacing.footerHintGap,
                  WorkoutResultZoneCard(
                    zoneProportions: state.zoneProportions,
                    dominantZone: state.dominantZone,
                    dominantZonePercent: state.dominantZonePercent,
                  ),
                  AppSpacing.footerHintGap,
                  const RunZoneActionCard(
                    icon: RunZoneIconAsset.lap,
                    title: '랩·페이스 상세 분석',
                    subtitle: '5랩 · 평균 페이스 6:17/km',
                  ),
                  AppSpacing.footerHintGap,
                  const RunZoneActionCard(
                    icon: RunZoneIconAsset.activity,
                    title: '오늘 훈련 부하 · 회복',
                    subtitle: '회복도 82 · 위험 낮음',
                  ),
                  const Spacer(),
                  RunZonePrimaryButton(label: '확인', onPressed: () => context.go(AppRoutes.home)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
