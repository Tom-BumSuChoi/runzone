import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/domain/gender.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone_calculator.dart';
import 'package:runzone/features/workout/domain/height.dart';
import 'package:runzone/features/workout/domain/running_career.dart';
import 'package:runzone/features/workout/domain/weekly_frequency.dart';
import 'package:runzone/features/workout/domain/weight.dart';
import 'package:runzone/features/workout/presentation/cubit/heart_rate_zone_setup_cubit.dart';

void main() {
  const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

  test('Given 새로 생성한 cubit When 초기 상태를 확인하면 Then 기본값과 그에 따른 심박존을 가진다', () {
    final HeartRateZoneSetupCubit cubit = HeartRateZoneSetupCubit();

    expect(cubit.state, HeartRateZoneSetupState.initial());
    expect(cubit.state.zone, calculator.getHeartRateZone(age: 30));
  });

  group('나이 조절', () {
    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When incrementAge 하면 Then 나이가 1 늘고 그에 따른 심박존을 방출한다',
      build: HeartRateZoneSetupCubit.new,
      act: (cubit) => cubit.incrementAge(),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(age: 31)],
      verify: (cubit) => expect(cubit.state.zone, calculator.getHeartRateZone(age: 31)),
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When decrementAge 하면 Then 나이가 1 줄고 그에 따른 심박존을 방출한다',
      build: HeartRateZoneSetupCubit.new,
      act: (cubit) => cubit.decrementAge(),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(age: 29)],
      verify: (cubit) => expect(cubit.state.zone, calculator.getHeartRateZone(age: 29)),
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given 최대 나이 상태 When incrementAge 하면 Then 더 증가하지 않고 아무것도 방출하지 않는다',
      build: HeartRateZoneSetupCubit.new,
      seed: () => HeartRateZoneSetupState.initial().copyWith(age: 120),
      act: (cubit) => cubit.incrementAge(),
      expect: () => const <HeartRateZoneSetupState>[],
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given 최소 나이 상태 When decrementAge 하면 Then 더 감소하지 않고 아무것도 방출하지 않는다',
      build: HeartRateZoneSetupCubit.new,
      seed: () => HeartRateZoneSetupState.initial().copyWith(age: 1),
      act: (cubit) => cubit.decrementAge(),
      expect: () => const <HeartRateZoneSetupState>[],
    );
  });

  group('프로필 필드 변경 (심박존 영향 없음)', () {
    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When changeGender 하면 Then 성별만 갱신된다',
      build: HeartRateZoneSetupCubit.new,
      act: (cubit) => cubit.changeGender(Gender.female),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(gender: Gender.female)],
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When changeHeight 하면 Then 키만 갱신된다',
      build: HeartRateZoneSetupCubit.new,
      act: (cubit) => cubit.changeHeight(175),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(height: Height(175))],
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When changeWeight 하면 Then 체중만 갱신된다',
      build: HeartRateZoneSetupCubit.new,
      act: (cubit) => cubit.changeWeight(68),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(weight: Weight(68))],
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When changeCareer 하면 Then 러닝 경력만 갱신된다',
      build: HeartRateZoneSetupCubit.new,
      act: (cubit) => cubit.changeCareer(RunningCareer.intermediate),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(career: RunningCareer.intermediate)],
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When changeWeeklyFrequency 하면 Then 주간 빈도만 갱신된다',
      build: HeartRateZoneSetupCubit.new,
      act: (cubit) => cubit.changeWeeklyFrequency(5),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(weeklyFrequency: WeeklyFrequency(5))],
    );
  });
}
