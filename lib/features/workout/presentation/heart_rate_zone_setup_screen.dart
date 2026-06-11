import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runzone/app/di.dart';
import 'package:runzone/core/design_system/app_spacing.dart';
import 'package:runzone/core/design_system/widgets/run_zone_card.dart';
import 'package:runzone/core/design_system/widgets/run_zone_choice_chip.dart';
import 'package:runzone/core/design_system/widgets/run_zone_primary_button.dart';
import 'package:runzone/core/design_system/widgets/run_zone_profile_field.dart';
import 'package:runzone/core/design_system/widgets/run_zone_progress_indicator.dart';
import 'package:runzone/core/design_system/widgets/run_zone_section_label.dart';
import 'package:runzone/core/design_system/widgets/run_zone_stepper.dart';
import 'package:runzone/features/workout/domain/profile_repository.dart';
import 'package:runzone/features/workout/presentation/cubit/heart_rate_zone_setup_cubit.dart';

final class HeartRateZoneSetupScreen extends StatelessWidget {
  const HeartRateZoneSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HeartRateZoneSetupCubit(getIt<ProfileRepository>()),
      child: const _HeartRateZoneSetupView(),
    );
  }
}

final class _HeartRateZoneSetupView extends StatelessWidget {
  const _HeartRateZoneSetupView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenInsets,
          child: BlocBuilder<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
            builder: (context, state) {
              final cubit = context.read<HeartRateZoneSetupCubit>();
              return Column(
                crossAxisAlignment: .start,
                children: [
                  const _SetupHeader(),
                  AppSpacing.looseGap,
                  _BasicInfoSection(state: state, cubit: cubit),
                  AppSpacing.looseGap,
                  _CareerSection(state: state, cubit: cubit),
                  AppSpacing.looseGap,
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
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        const RunZoneProgressIndicator(totalSteps: 2, currentStep: 2),
        AppSpacing.wideGap,
        Text('프로필 입력', style: textTheme.headlineLarge),
        AppSpacing.tightGap,
        Text('이 정보로 당신의 심박존을 자동 계산해요', style: textTheme.bodySmall),
      ],
    );
  }
}

final class _BasicInfoSection extends StatelessWidget {
  const _BasicInfoSection({required this.state, required this.cubit});

  final HeartRateZoneSetupState state;
  final HeartRateZoneSetupCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const RunZoneSectionLabel('기본 정보'),
        AppSpacing.closeGap,
        RunZoneCard(
          child: Column(
            children: [
              RunZoneProfileField(
                label: '성별',
                trailing: _GenderSelector(state: state, cubit: cubit),
              ),
              const Divider(),
              RunZoneProfileField(
                label: '출생 연도',
                subLabel: '만 ${state.age}세',
                trailing: RunZoneStepper(
                  value: state.birthYear.year,
                  onDecrement: cubit.decrementBirthYear,
                  onIncrement: cubit.incrementBirthYear,
                ),
              ),
              const Divider(),
              RunZoneProfileField(
                label: '키',
                subLabel: 'cm',
                trailing: RunZoneStepper(
                  value: state.height.centimeters,
                  onDecrement: cubit.decrementHeight,
                  onIncrement: cubit.incrementHeight,
                ),
              ),
              const Divider(),
              RunZoneProfileField(
                label: '체중',
                subLabel: 'kg',
                trailing: RunZoneStepper(
                  value: state.weight.kilograms,
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

  final HeartRateZoneSetupState state;
  final HeartRateZoneSetupCubit cubit;

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

  final HeartRateZoneSetupState state;
  final HeartRateZoneSetupCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const RunZoneSectionLabel('러닝 경력'),
        AppSpacing.closeGap,
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

  final HeartRateZoneSetupState state;
  final HeartRateZoneSetupCubit cubit;

  bool get _isLowFrequency => state.weeklyFrequency.count <= 2;
  bool get _isMediumFrequency => state.weeklyFrequency.count >= 3 && state.weeklyFrequency.count <= 4;
  bool get _isHighFrequency => state.weeklyFrequency.count >= 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const RunZoneSectionLabel('주간 러닝 빈도'),
        AppSpacing.closeGap,
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
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text('나중에 설정에서 언제든 변경할 수 있어요', textAlign: TextAlign.center, style: textTheme.labelSmall),
        ),
        AppSpacing.closeGap,
        RunZonePrimaryButton(label: '시작하기', onPressed: onComplete),
      ],
    );
  }
}
