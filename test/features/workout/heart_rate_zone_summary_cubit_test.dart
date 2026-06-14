import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';
import 'package:runzone/features/workout/presentation/cubit/heart_rate_zone_summary_cubit.dart';

final class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository(this._profile);

  final RunnerProfile? _profile;

  @override
  Future<void> save(RunnerProfile profile) async {}

  @override
  Future<RunnerProfile?> load() async => _profile;
}

void main() {
  const HeartRateZone customHeartRateZone = HeartRateZone(
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
    heartRateZone: customHeartRateZone,
  );

  test('Given 새로 생성한 cubit When 초기 상태를 확인하면 Then loading 상태이다', () {
    final HeartRateZoneSummaryCubit cubit = HeartRateZoneSummaryCubit(_FakeProfileRepository(profile));

    expect(cubit.state, HeartRateZoneSummaryState.initial());
  });

  blocTest<HeartRateZoneSummaryCubit, HeartRateZoneSummaryState>(
    'Given 저장된 프로필 When load 하면 Then 프로필의 심박존을 담아 loaded 상태를 방출한다',
    build: () => HeartRateZoneSummaryCubit(_FakeProfileRepository(profile)),
    act: (cubit) => cubit.load(),
    expect: () => [HeartRateZoneSummaryState(zone: customHeartRateZone)],
  );

  blocTest<HeartRateZoneSummaryCubit, HeartRateZoneSummaryState>(
    'Given 저장된 프로필이 없으면 When load 하면 Then 아무것도 방출하지 않는다',
    build: () => HeartRateZoneSummaryCubit(_FakeProfileRepository(null)),
    act: (cubit) => cubit.load(),
    expect: () => const <HeartRateZoneSummaryState>[],
  );
}
