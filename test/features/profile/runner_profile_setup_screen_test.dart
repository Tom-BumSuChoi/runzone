import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runzone/app/di.dart';
import 'package:runzone/core/design_system/app_theme.dart';
import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';
import 'package:runzone/features/profile/presentation/runner_profile_setup_screen.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_zone_calculator.dart';
import '../../helpers/test_device_size.dart';

final class _SpyProfileRepository implements ProfileRepository {
  RunnerProfile? saved;
  int saveCount = 0;
  Completer<void>? completer;
  final StreamController<RunnerProfile?> _controller = StreamController<RunnerProfile?>.broadcast();

  @override
  Future<void> save(RunnerProfile profile) async {
    saveCount += 1;
    saved = profile;
    await completer?.future;
    _controller.add(profile);
  }

  @override
  Future<RunnerProfile?> load() async => null;

  @override
  Stream<RunnerProfile?> watchProfile() => _controller.stream;

  Future<void> close() => _controller.close();
}

void main() {
  const HeartRateZoneCalculator calculator = HeartRateZoneCalculator();
  late _SpyProfileRepository repository;

  setUp(() {
    repository = _SpyProfileRepository();
    getIt.registerSingleton<ProfileRepository>(repository);
  });

  tearDown(() async {
    await repository.close();
    await getIt.reset();
  });

  testWidgets('Given 기본 정보 화면 When 처음 열면 Then 초기 프로필 값이 보인다', (tester) async {
    tester.view.physicalSize = testDeviceSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: const RunnerProfileSetupScreen()));

    expect(find.text('남'), findsOneWidget);
    expect(find.text('1996'), findsOneWidget);
    expect(find.text('170'), findsOneWidget);
    expect(find.text('65'), findsOneWidget);
    expect(find.text('초보'), findsOneWidget);
    expect(find.text('3-4회'), findsOneWidget);
  });

  testWidgets('Given 기본 정보 화면 When 값을 변경하고 시작하면 Then 변경된 RunnerProfile을 저장한다', (tester) async {
    tester.view.physicalSize = testDeviceSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: const RunnerProfileSetupScreen()));

    await tester.tap(find.text('여'));
    await tester.tap(find.byIcon(Icons.add).at(0));
    await tester.tap(find.byIcon(Icons.add).at(1));
    await tester.tap(find.byIcon(Icons.remove).at(2));
    await tester.tap(find.text('숙련'));
    await tester.tap(find.text('5회+'));
    await tester.tap(find.text('시작하기'));
    await tester.pump();

    expect(
      repository.saved,
      RunnerProfile(
        birthYear: BirthYear(1997),
        gender: Gender.female,
        height: Height(171),
        weight: Weight(64),
        career: RunningCareer.advanced,
        weeklyFrequency: WeeklyFrequency(5),
        heartRateZone: calculator.getHeartRateZone(age: DateTime.now().year - 1997),
      ),
    );
  });

  testWidgets('Given 저장 중인 기본 정보 화면 When 시작하기를 다시 눌러도 Then 중복 저장하지 않는다', (tester) async {
    final completer = Completer<void>();
    repository.completer = completer;
    tester.view.physicalSize = testDeviceSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: const RunnerProfileSetupScreen()));

    await tester.tap(find.text('시작하기'));
    await tester.pump();
    await tester.tap(find.text('시작하기'));
    await tester.pump();

    expect(repository.saveCount, 1);

    completer.complete();
  });
}
