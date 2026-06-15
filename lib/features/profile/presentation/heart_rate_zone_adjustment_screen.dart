import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../core/design_system/app_color_scheme.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/bar/segmented_bar.dart';
import '../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../core/design_system/widgets/label/run_zone_section_label.dart';
import '../../../core/design_system/widgets/slider/labeled_slider.dart';
import '../../../core/design_system/widgets/label/run_zone_description_label.dart';
import '../../../core/design_system/widgets/label/run_zone_title_label.dart';
import '../domain/profile_repository.dart';
import 'cubit/heart_rate_zone_adjustment_cubit.dart';

final class HeartRateZoneAdjustmentScreen extends StatelessWidget {
  const HeartRateZoneAdjustmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HeartRateZoneAdjustmentCubit(getIt<ProfileRepository>()),
      child: const _HeartRateZoneAdjustmentView(),
    );
  }
}

final class _HeartRateZoneAdjustmentView extends StatelessWidget {
  const _HeartRateZoneAdjustmentView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenInsets,
          child: BlocBuilder<HeartRateZoneAdjustmentCubit, HeartRateZoneAdjustmentState>(
            builder: (context, state) {
              final cubit = context.read<HeartRateZoneAdjustmentCubit>();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RunZoneTitleLabel('심박존 조정'),
                  AppSpacing.titleDescriptionGap,
                  const RunZoneDescriptionLabel('슬라이더로 각 존의 경계를 직접 맞춰요.'),
                  AppSpacing.sectionGap,
                  switch (state) {
                    HeartRateZoneAdjustmentLoading() => const SizedBox.shrink(),
                    HeartRateZoneAdjustmentEditing() => _HeartRateZoneAdjustmentContent(state: state, cubit: cubit),
                  },
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

final class _HeartRateZoneAdjustmentContent extends StatelessWidget {
  const _HeartRateZoneAdjustmentContent({required this.state, required this.cubit});

  final HeartRateZoneAdjustmentEditing state;
  final HeartRateZoneAdjustmentCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeartRateZoneSegmentedBarCard(state: state),
        AppSpacing.sectionGap,
        const RunZoneSectionLabel('존 경계'),
        AppSpacing.sectionLabelGap,
        _HeartRateZoneBoundaryCard(state: state, cubit: cubit),
      ],
    );
  }
}

final class _HeartRateZoneSegmentedBarCard extends StatelessWidget {
  const _HeartRateZoneSegmentedBarCard({required this.state});

  final HeartRateZoneAdjustmentEditing state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RunZoneCard(
      child: RunZoneSegmentedBar(
        segments: [
          RunZoneSegmentData(label: 'Z1', color: colorScheme.zoneOne, heightFactor: state.zoneOneHeightFactor),
          RunZoneSegmentData(label: 'Z2', color: colorScheme.zoneTwo, heightFactor: state.zoneTwoHeightFactor),
          RunZoneSegmentData(label: 'Z3', color: colorScheme.zoneThree, heightFactor: state.zoneThreeHeightFactor),
          RunZoneSegmentData(label: 'Z4', color: colorScheme.zoneFour, heightFactor: state.zoneFourHeightFactor),
          RunZoneSegmentData(label: 'Z5', color: colorScheme.zoneFive, heightFactor: state.zoneFiveHeightFactor),
        ],
      ),
    );
  }
}

final class _HeartRateZoneBoundaryCard extends StatelessWidget {
  const _HeartRateZoneBoundaryCard({required this.state, required this.cubit});

  final HeartRateZoneAdjustmentEditing state;
  final HeartRateZoneAdjustmentCubit cubit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RunZoneCard(
      child: Column(
        spacing: AppSpacing.controlGroupGap,
        children: [
          RunZoneLabeledSlider(
            label: 'Z1 → Z2',
            valueLabel: state.zoneOneUpperBound.toString(),
            unitLabel: 'bpm',
            value: state.zoneOneUpperBound.toDouble(),
            leadingColor: colorScheme.zoneOne,
            trailingColor: colorScheme.zoneTwo,
            minimum: state.zoneOneMinimum.toDouble(),
            maximum: state.zoneOneMaximum.toDouble(),
            onChanged: (value) => cubit.updateZoneOneUpperBound(value.round()),
          ),
          RunZoneLabeledSlider(
            label: 'Z2 → Z3',
            valueLabel: state.zoneTwoUpperBound.toString(),
            unitLabel: 'bpm',
            value: state.zoneTwoUpperBound.toDouble(),
            leadingColor: colorScheme.zoneTwo,
            trailingColor: colorScheme.zoneThree,
            minimum: state.zoneTwoMinimum.toDouble(),
            maximum: state.zoneTwoMaximum.toDouble(),
            onChanged: (value) => cubit.updateZoneTwoUpperBound(value.round()),
          ),
          RunZoneLabeledSlider(
            label: 'Z3 → Z4',
            valueLabel: state.zoneThreeUpperBound.toString(),
            unitLabel: 'bpm',
            value: state.zoneThreeUpperBound.toDouble(),
            leadingColor: colorScheme.zoneThree,
            trailingColor: colorScheme.zoneFour,
            minimum: state.zoneThreeMinimum.toDouble(),
            maximum: state.zoneThreeMaximum.toDouble(),
            onChanged: (value) => cubit.updateZoneThreeUpperBound(value.round()),
          ),
          RunZoneLabeledSlider(
            label: 'Z4 → Z5',
            valueLabel: state.zoneFourUpperBound.toString(),
            unitLabel: 'bpm',
            value: state.zoneFourUpperBound.toDouble(),
            leadingColor: colorScheme.zoneFour,
            trailingColor: colorScheme.zoneFive,
            minimum: state.zoneFourMinimum.toDouble(),
            maximum: state.zoneFourMaximum.toDouble(),
            onChanged: (value) => cubit.updateZoneFourUpperBound(value.round()),
          ),
        ],
      ),
    );
  }
}
