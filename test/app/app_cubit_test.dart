import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/app/cubit/app_cubit.dart';
import 'package:runzone/features/profile/domain/birth_year.dart';
import 'package:runzone/features/profile/domain/gender.dart';
import 'package:runzone/features/profile/domain/height.dart';
import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';
import 'package:runzone/features/profile/domain/running_career.dart';
import 'package:runzone/features/profile/domain/weekly_frequency.dart';
import 'package:runzone/features/profile/domain/weight.dart';

final class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository(this._profile);

  final RunnerProfile? _profile;

  @override
  Future<void> save(RunnerProfile profile) async {}

  @override
  Future<RunnerProfile?> load() async => _profile;
}

void main() {
  final RunnerProfile profile = RunnerProfile(
    birthYear: BirthYear(1996),
    gender: Gender.male,
    height: Height(170),
    weight: Weight(65),
    career: RunningCareer.beginner,
    weeklyFrequency: WeeklyFrequency(3),
  );

  test('Given 새로 생성한 cubit When 초기화 완료 전 상태를 확인하면 Then AppInitial(loading)이다', () {
    final AppCubit cubit = AppCubit(repository: _FakeProfileRepository(profile));

    expect(cubit.state, const AppInitial());
  });

  blocTest<AppCubit, AppState>(
    'Given 저장된 프로필이 있으면 When 초기화되면 Then hasProfile=true인 AppReady를 방출한다',
    build: () => AppCubit(repository: _FakeProfileRepository(profile)),
    expect: () => const [AppReady(hasProfile: true)],
  );

  blocTest<AppCubit, AppState>(
    'Given 저장된 프로필이 없으면 When 초기화되면 Then hasProfile=false인 AppReady를 방출한다',
    build: () => AppCubit(repository: _FakeProfileRepository(null)),
    expect: () => const [AppReady(hasProfile: false)],
  );
}
