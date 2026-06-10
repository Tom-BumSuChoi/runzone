import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone_calculator.dart';
import 'package:runzone/features/workout/presentation/cubit/heart_rate_zone_setup_cubit.dart';

void main() {
  const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

  test('Given 새로 생성한 cubit When 초기 상태를 확인하면 Then 기본 나이 30세와 그에 따른 심박존을 가진다', () {
    // Given
    const int defaultAge = 30;

    // When
    final HeartRateZoneSetupCubit cubit = HeartRateZoneSetupCubit();

    // Then
    expect(cubit.state.age, defaultAge);
    expect(cubit.state.zone, calculator.getHeartRateZone(age: defaultAge));
  });

  group('나이 조절', () {
    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When incrementAge 하면 Then 나이가 1 늘고 그에 따른 심박존을 방출한다',
      build: HeartRateZoneSetupCubit.new,
      act: (cubit) => cubit.incrementAge(),
      expect: () => const [HeartRateZoneSetupState(age: 31)],
      verify: (cubit) => expect(cubit.state.zone, calculator.getHeartRateZone(age: 31)),
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given cubit When decrementAge 하면 Then 나이가 1 줄고 그에 따른 심박존을 방출한다',
      build: HeartRateZoneSetupCubit.new,
      act: (cubit) => cubit.decrementAge(),
      expect: () => const [HeartRateZoneSetupState(age: 29)],
      verify: (cubit) => expect(cubit.state.zone, calculator.getHeartRateZone(age: 29)),
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given 최대 나이 상태 When incrementAge 하면 Then 더 증가하지 않고 아무것도 방출하지 않는다',
      build: HeartRateZoneSetupCubit.new,
      seed: () => const HeartRateZoneSetupState(age: 120),
      act: (cubit) => cubit.incrementAge(),
      expect: () => const <HeartRateZoneSetupState>[],
    );

    blocTest<HeartRateZoneSetupCubit, HeartRateZoneSetupState>(
      'Given 최소 나이 상태 When decrementAge 하면 Then 더 감소하지 않고 아무것도 방출하지 않는다',
      build: HeartRateZoneSetupCubit.new,
      seed: () => const HeartRateZoneSetupState(age: 1),
      act: (cubit) => cubit.decrementAge(),
      expect: () => const <HeartRateZoneSetupState>[],
    );
  });
}
