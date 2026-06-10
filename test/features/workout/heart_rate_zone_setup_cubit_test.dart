import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/domain/gender.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone_calculator.dart';
import 'package:runzone/features/workout/domain/height.dart';
import 'package:runzone/features/workout/domain/profile_repository.dart';
import 'package:runzone/features/workout/domain/runner_profile.dart';
import 'package:runzone/features/workout/domain/running_career.dart';
import 'package:runzone/features/workout/domain/weekly_frequency.dart';
import 'package:runzone/features/workout/domain/weight.dart';
import 'package:runzone/features/workout/presentation/cubit/heart_rate_zone_setup_cubit.dart';

class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<void> save(RunnerProfile profile) async {}
}

class _SpyProfileRepository implements ProfileRepository {
  RunnerProfile? saved;

  @override
  Future<void> save(RunnerProfile profile) async {
    saved = profile;
  }
}

class _ThrowingProfileRepository implements ProfileRepository {
  @override
  Future<void> save(RunnerProfile profile) async {
    throw Exception('save failed');
  }
}

void main() {
  const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

  HeartRateZoneSetupCubit buildCubit() => HeartRateZoneSetupCubit(_FakeProfileRepository());

  test('Given 새로 생성한 cubit When 초기 상태를 확인하면 Then 기본값과 그에 따른 심박존을 가진다', () {
    final HeartRateZoneSetupCubit cubit = buildCubit();

    expect(cubit.state, HeartRateZoneSetupState.initial());
    expect(cubit.state.zone, calculator.getHeartRateZone(age: 30));
  });

  group('나이 조절', () {
    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When incrementAge 하면 Then 나이가 1 늘고 그에 따른 심박존을 방출한다',
      build: buildCubit,
      act: (cubit) => cubit.incrementAge(),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(age: 31)],
      verify: (cubit) => expect(cubit.state.zone, calculator.getHeartRateZone(age: 31)),
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When decrementAge 하면 Then 나이가 1 줄고 그에 따른 심박존을 방출한다',
      build: buildCubit,
      act: (cubit) => cubit.decrementAge(),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(age: 29)],
      verify: (cubit) => expect(cubit.state.zone, calculator.getHeartRateZone(age: 29)),
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given 최대 나이 상태 When incrementAge 하면 Then 더 증가하지 않고 아무것도 방출하지 않는다',
      build: buildCubit,
      seed: () => HeartRateZoneSetupState.initial().copyWith(age: 120),
      act: (cubit) => cubit.incrementAge(),
      expect: () => const <HeartRateZoneSetupState>[],
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given 최소 나이 상태 When decrementAge 하면 Then 더 감소하지 않고 아무것도 방출하지 않는다',
      build: buildCubit,
      seed: () => HeartRateZoneSetupState.initial().copyWith(age: 1),
      act: (cubit) => cubit.decrementAge(),
      expect: () => const <HeartRateZoneSetupState>[],
    );
  });

  group('프로필 필드 변경 (심박존 영향 없음)', () {
    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When changeGender 하면 Then 성별만 갱신된다',
      build: buildCubit,
      act: (cubit) => cubit.changeGender(Gender.female),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(gender: Gender.female)],
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When changeHeight 하면 Then 키만 갱신된다',
      build: buildCubit,
      act: (cubit) => cubit.changeHeight(175),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(height: Height(175))],
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When changeWeight 하면 Then 체중만 갱신된다',
      build: buildCubit,
      act: (cubit) => cubit.changeWeight(68),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(weight: Weight(68))],
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When changeCareer 하면 Then 러닝 경력만 갱신된다',
      build: buildCubit,
      act: (cubit) => cubit.changeCareer(RunningCareer.intermediate),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(career: RunningCareer.intermediate)],
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When changeWeeklyFrequency 하면 Then 주간 빈도만 갱신된다',
      build: buildCubit,
      act: (cubit) => cubit.changeWeeklyFrequency(5),
      expect: () => [HeartRateZoneSetupState.initial().copyWith(weeklyFrequency: WeeklyFrequency(5))],
    );
  });

  group('완료', () {
    late _SpyProfileRepository spy;

    setUp(() => spy = _SpyProfileRepository());

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When complete 하면 Then submitting→success를 방출하고 프로필을 저장한다',
      build: () => HeartRateZoneSetupCubit(spy),
      act: (cubit) => cubit.complete(),
      expect: () => [
        HeartRateZoneSetupState.initial().copyWith(status: SetupStatus.submitting),
        HeartRateZoneSetupState.initial().copyWith(status: SetupStatus.success),
      ],
      verify: (_) => expect(
        spy.saved,
        RunnerProfile(
          age: 30,
          gender: Gender.male,
          height: Height(170),
          weight: Weight(65),
          career: RunningCareer.beginner,
          weeklyFrequency: WeeklyFrequency(3),
        ),
      ),
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given 저장이 실패하는 cubit When complete 하면 Then submitting→failure를 방출한다',
      build: () => HeartRateZoneSetupCubit(_ThrowingProfileRepository()),
      act: (cubit) => cubit.complete(),
      expect: () => [
        HeartRateZoneSetupState.initial().copyWith(status: SetupStatus.submitting),
        HeartRateZoneSetupState.initial().copyWith(status: SetupStatus.failure),
      ],
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given submitting 상태 When complete 하면 Then 무시되어 아무것도 방출하지 않는다',
      build: buildCubit,
      seed: () => HeartRateZoneSetupState.initial().copyWith(status: SetupStatus.submitting),
      act: (cubit) => cubit.complete(),
      expect: () => const <HeartRateZoneSetupState>[],
    );
  });
}
