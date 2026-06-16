import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/app/di.dart';
import 'package:runzone/app/main_shell.dart';
import 'package:runzone/core/design_system/app_theme.dart';
import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';

final class _FakeProfileRepository implements ProfileRepository {
  const _FakeProfileRepository(this._profile);

  final RunnerProfile _profile;

  @override
  Future<RunnerProfile?> load() async => _profile;

  @override
  Future<void> save(RunnerProfile profile) async {}

  @override
  Stream<RunnerProfile?> watchProfile() => Stream<RunnerProfile?>.empty();
}

void main() {
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
    getIt.registerSingleton<ProfileRepository>(_FakeProfileRepository(profile));
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('Given 저장된 프로필이 있는 메인 쉘 When 마이페이지를 누르면 Then 심박존 경계값이 보인다', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: const MainShell()));

    await tester.tap(find.text('마이페이지'));
    await tester.pump();
    await tester.pump();

    expect(find.text('심박존 조정'), findsOneWidget);
    expect(find.text('Z1 → Z2'), findsOneWidget);
    expect(find.text('120'), findsOneWidget);
    expect(find.text('Z2 → Z3'), findsOneWidget);
    expect(find.text('140'), findsOneWidget);
    expect(find.text('Z3 → Z4'), findsOneWidget);
    expect(find.text('160'), findsOneWidget);
    expect(find.text('Z4 → Z5'), findsOneWidget);
    expect(find.text('180'), findsOneWidget);
    expect(find.text('bpm'), findsWidgets);
  });
}
