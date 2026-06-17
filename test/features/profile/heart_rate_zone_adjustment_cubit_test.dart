import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';
import 'package:runzone/features/profile/presentation/cubit/heart_rate_zone_adjustment_cubit.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_zone_calculator.dart';

final class _SpyProfileRepository implements ProfileRepository {
  _SpyProfileRepository(this._profile);

  final RunnerProfile? _profile;
  final Completer<void> _loadCompleter = Completer<void>();
  RunnerProfile? saved;
  Future<RunnerProfile?>? loadFuture;

  Future<void> get loadCompleted => _loadCompleter.future;

  @override
  Future<RunnerProfile?> load() async {
    final RunnerProfile? loadedProfile = await (loadFuture ?? Future<RunnerProfile?>.value(_profile));
    if (!_loadCompleter.isCompleted) {
      _loadCompleter.complete();
    }

    return loadedProfile;
  }

  @override
  Future<void> save(RunnerProfile profile) async {
    saved = profile;
  }

  @override
  Stream<RunnerProfile?> watchProfile() => Stream<RunnerProfile?>.empty();
}

void main() {
  late _SpyProfileRepository repository;

  const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();

  const HeartRateZoneTable heartRateZone = HeartRateZoneTable(
    zone1: HeartRateZoneRange(lower: 90, upper: 120),
    zone2: HeartRateZoneRange(lower: 121, upper: 140),
    zone3: HeartRateZoneRange(lower: 141, upper: 160),
    zone4: HeartRateZoneRange(lower: 161, upper: 180),
    zone5: HeartRateZoneRange(lower: 181, upper: 200),
  );

  final RunnerProfile profile = RunnerProfile(
    birthYear: BirthYear(1996),
    gender: Gender.male,
    height: Height(170),
    weight: Weight(65),
    career: RunningCareer.beginner,
    weeklyFrequency: WeeklyFrequency(3),
    heartRateZone: heartRateZone,
  );

  setUp(() {
    repository = _SpyProfileRepository(profile);
  });

  blocTest<HeartRateZoneAdjustmentCubit, HeartRateZoneAdjustmentState>(
    'Given 저장된 프로필 When cubit을 생성하면 Then 프로필의 심박존을 상태로 방출한다',
    build: () => HeartRateZoneAdjustmentCubit(repository),
    expect: () => [const HeartRateZoneAdjustmentEditing(zone: heartRateZone)],
  );

  blocTest<HeartRateZoneAdjustmentCubit, HeartRateZoneAdjustmentState>(
    'Given 저장된 프로필 When 존 경계를 변경하면 Then 상태를 바꾸고 프로필을 즉시 저장한다',
    build: () => HeartRateZoneAdjustmentCubit(repository),
    act: (cubit) async {
      await repository.loadCompleted;
      await cubit.updateZoneOneUpperBound(125);
    },
    expect: () => [
      const HeartRateZoneAdjustmentEditing(zone: heartRateZone),
      const HeartRateZoneAdjustmentEditing(
        zone: HeartRateZoneTable(
          zone1: HeartRateZoneRange(lower: 90, upper: 125),
          zone2: HeartRateZoneRange(lower: 126, upper: 140),
          zone3: HeartRateZoneRange(lower: 141, upper: 160),
          zone4: HeartRateZoneRange(lower: 161, upper: 180),
          zone5: HeartRateZoneRange(lower: 181, upper: 200),
        ),
      ),
    ],
    verify: (cubit) {
      expect(repository.saved?.heartRateZone.zone1.upper, 125);
      expect(repository.saved?.heartRateZone.zone2.lower, 126);
    },
  );

  blocTest<HeartRateZoneAdjustmentCubit, HeartRateZoneAdjustmentState>(
    'Given 조정된 심박존 When 프로필 기준으로 되돌리면 Then 기본 심박존을 즉시 저장한다',
    build: () => HeartRateZoneAdjustmentCubit(repository),
    act: (cubit) async {
      await repository.loadCompleted;
      await cubit.restoreProfileZones();
    },
    expect: () {
      final HeartRateZoneTable profileZone = calculator.getHeartRateZone(age: DateTime.now().year - profile.birthYear.year);

      return [
        const HeartRateZoneAdjustmentEditing(zone: heartRateZone),
        HeartRateZoneAdjustmentEditing(zone: profileZone),
      ];
    },
    verify: (cubit) {
      final HeartRateZoneTable profileZone = calculator.getHeartRateZone(age: DateTime.now().year - profile.birthYear.year);

      expect(repository.saved?.heartRateZone, profileZone);
    },
  );

  test('Given 로드 완료 전에 cubit이 닫히면 When load가 완료되어도 Then 상태를 방출하지 않는다', () async {
    final completer = Completer<RunnerProfile?>();
    repository.loadFuture = completer.future;
    final cubit = HeartRateZoneAdjustmentCubit(repository);

    await cubit.close();
    completer.complete(profile);

    await expectLater(cubit.stream, emitsDone);
  });
}
