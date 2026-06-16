import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/design_system/widgets/button/run_zone_primary_button.dart';
import '../../../core/design_system/widgets/card/run_zone_card.dart';
import '../../../core/design_system/widgets/chip/run_zone_choice_chip.dart';
import '../../../core/design_system/widgets/label/run_zone_body_small_label.dart';
import '../../../core/design_system/widgets/label/run_zone_headline_large_label.dart';
import '../../../core/design_system/widgets/label/run_zone_label_small_label.dart';
import '../../../core/design_system/widgets/list/run_zone_list_item.dart';
import '../../../core/design_system/widgets/progress/run_zone_progress_indicator.dart';
import '../../../core/design_system/widgets/stepper/run_zone_stepper.dart';
import '../domain/profile_repository.dart';
import 'cubit/runner_profile_setup_cubit.dart';

final class RunnerProfileSetupScreen extends StatelessWidget {
  const RunnerProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RunnerProfileSetupCubit(getIt<ProfileRepository>()),
      child: const _RunnerProfileSetupView(),
    );
  }
}

final class _RunnerProfileSetupView extends StatelessWidget {
  const _RunnerProfileSetupView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenInsets,
          child: BlocBuilder<RunnerProfileSetupCubit, RunnerProfileSetupState>(
            builder: (context, state) {
              final cubit = context.read<RunnerProfileSetupCubit>();
              return Column(
                crossAxisAlignment: .start,
                children: [
                  const _SetupHeader(),
                  AppSpacing.sectionGap,
                  _BasicInfoSection(state: state, cubit: cubit),
                  AppSpacing.sectionGap,
                  _CareerSection(state: state, cubit: cubit),
                  AppSpacing.sectionGap,
                  _WeeklyFrequencySection(state: state, cubit: cubit),
                  const Spacer(),
                  _SetupFooter(onComplete: cubit.complete),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

final class _SetupHeader extends StatelessWidget {
  const _SetupHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const RunZoneProgressIndicator(totalSteps: 2, currentStep: 2),
        AppSpacing.headerTitleGap,
        const RunZoneHeadlineLargeLabel('프로필 입력'),
        AppSpacing.titleDescriptionGap,
        const RunZoneBodySmallLabel('이 정보로 당신의 심박존을 자동 계산해요'),
      ],
    );
  }
}

final class _BasicInfoSection extends StatelessWidget {
  const _BasicInfoSection({required this.state, required this.cubit});

  final RunnerProfileSetupState state;
  final RunnerProfileSetupCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const RunZoneLabelSmallLabel('기본 정보'),
        AppSpacing.sectionLabelGap,
        RunZoneCard(
          child: Column(
            children: [
              RunZoneListItem(
                title: '성별',
                trailing: _GenderSelector(state: state, cubit: cubit),
              ),
              const Divider(),
              RunZoneListItem(
                title: '출생 연도',
                subtitle: '만 ${state.age}세',
                trailing: RunZoneStepper(
                  label: '${state.birthYear.year}',
                  onDecrement: cubit.decrementBirthYear,
                  onIncrement: cubit.incrementBirthYear,
                ),
              ),
              const Divider(),
              RunZoneListItem(
                title: '키',
                subtitle: 'cm',
                trailing: RunZoneStepper(
                  label: '${state.height.centimeters}',
                  onDecrement: cubit.decrementHeight,
                  onIncrement: cubit.incrementHeight,
                ),
              ),
              const Divider(),
              RunZoneListItem(
                title: '체중',
                subtitle: 'kg',
                trailing: RunZoneStepper(
                  label: '${state.weight.kilograms}',
                  onDecrement: cubit.decrementWeight,
                  onIncrement: cubit.incrementWeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final class _GenderSelector extends StatelessWidget {
  const _GenderSelector({required this.state, required this.cubit});

  final RunnerProfileSetupState state;
  final RunnerProfileSetupCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.chipGap,
      children: [
        RunZoneChoiceChip(label: '남', isSelected: state.gender == .male, onTap: () => cubit.changeGender(.male)),
        RunZoneChoiceChip(label: '여', isSelected: state.gender == .female, onTap: () => cubit.changeGender(.female)),
      ],
    );
  }
}

final class _CareerSection extends StatelessWidget {
  const _CareerSection({required this.state, required this.cubit});

  final RunnerProfileSetupState state;
  final RunnerProfileSetupCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const RunZoneLabelSmallLabel('러닝 경력'),
        AppSpacing.sectionLabelGap,
        Row(
          spacing: AppSpacing.chipGap,
          children: [
            RunZoneChoiceChip(
              label: '입문',
              isSelected: state.career == .novice,
              onTap: () => cubit.changeCareer(.novice),
            ),
            RunZoneChoiceChip(
              label: '초보',
              isSelected: state.career == .beginner,
              onTap: () => cubit.changeCareer(.beginner),
            ),
            RunZoneChoiceChip(
              label: '중급',
              isSelected: state.career == .intermediate,
              onTap: () => cubit.changeCareer(.intermediate),
            ),
            RunZoneChoiceChip(
              label: '숙련',
              isSelected: state.career == .advanced,
              onTap: () => cubit.changeCareer(.advanced),
            ),
          ],
        ),
      ],
    );
  }
}

final class _WeeklyFrequencySection extends StatelessWidget {
  const _WeeklyFrequencySection({required this.state, required this.cubit});

  final RunnerProfileSetupState state;
  final RunnerProfileSetupCubit cubit;

  bool get _isLowFrequency => state.weeklyFrequency.count <= 2;
  bool get _isMediumFrequency => state.weeklyFrequency.count >= 3 && state.weeklyFrequency.count <= 4;
  bool get _isHighFrequency => state.weeklyFrequency.count >= 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const RunZoneLabelSmallLabel('주간 러닝 빈도'),
        AppSpacing.sectionLabelGap,
        Row(
          spacing: AppSpacing.chipGap,
          children: [
            RunZoneChoiceChip(label: '1-2회', isSelected: _isLowFrequency, onTap: () => cubit.changeWeeklyFrequency(1)),
            RunZoneChoiceChip(
              label: '3-4회',
              isSelected: _isMediumFrequency,
              onTap: () => cubit.changeWeeklyFrequency(3),
            ),
            RunZoneChoiceChip(label: '5회+', isSelected: _isHighFrequency, onTap: () => cubit.changeWeeklyFrequency(5)),
          ],
        ),
      ],
    );
  }
}

final class _SetupFooter extends StatelessWidget {
  const _SetupFooter({required this.onComplete});

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: const RunZoneLabelSmallLabel('나중에 설정에서 언제든 변경할 수 있어요', textAlign: TextAlign.center),
        ),
        AppSpacing.footerHintGap,
        RunZonePrimaryButton(label: '시작하기', onPressed: onComplete),
      ],
    );
  }
}
