import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runzone/app/cubit/app_cubit.dart';
import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone_calculator.dart';

final class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository(this._profile);

  RunnerProfile? _profile;
  final Completer<void> _initialProfileCompleter = Completer<void>();
  final StreamController<RunnerProfile?> _controller = StreamController<RunnerProfile?>.broadcast();

  Future<void> get initialProfileEmitted => _initialProfileCompleter.future;

  @override
  Future<void> save(RunnerProfile profile) async {
    _profile = profile;
    _controller.add(profile);
  }

  @override
  Future<RunnerProfile?> load() async => _profile;

  @override
  Stream<RunnerProfile?> watchProfile() async* {
    yield _profile;
    if (!_initialProfileCompleter.isCompleted) {
      _initialProfileCompleter.complete();
    }
    yield* _controller.stream;
  }

  void emitProfile(RunnerProfile? profile) {
    _profile = profile;
    _controller.add(profile);
  }

  Future<void> close() => _controller.close();
}

void main() {
  const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();
  final RunnerProfile profile = RunnerProfile(
    birthYear: BirthYear(1996),
    gender: Gender.male,
    height: Height(170),
    weight: Weight(65),
    career: RunningCareer.beginner,
    weeklyFrequency: WeeklyFrequency(3),
    heartRateZone: calculator.getHeartRateZone(age: DateTime.now().year - 1996),
  );

  test('Given 새로 생성한 cubit When 초기화 완료 전 상태를 확인하면 Then AppInitial(loading)이다', () {
    final _FakeProfileRepository repository = _FakeProfileRepository(profile);
    final AppCubit cubit = AppCubit(repository: repository);
    addTearDown(cubit.close);
    addTearDown(repository.close);

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

  group('프로필 상태 stream', () {
    late _FakeProfileRepository repository;

    setUp(() {
      repository = _FakeProfileRepository(null);
    });

    tearDown(() async {
      await repository.close();
    });

    blocTest<AppCubit, AppState>(
      'Given 저장된 프로필이 없으면 When repository가 프로필 변경을 알리면 Then hasProfile=true를 방출한다',
      build: () => AppCubit(repository: repository),
      act: (cubit) async {
        await repository.initialProfileEmitted;
        repository.emitProfile(profile);
      },
      expect: () => const [AppReady(hasProfile: false), AppReady(hasProfile: true)],
    );
  });
}
