import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'package:runzone/features/profile/data/shared_preferences_profile_repository.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';

final class _FailingSharedPreferencesStore extends InMemorySharedPreferencesStore {
  _FailingSharedPreferencesStore() : super.empty();

  @override
  Future<bool> setValue(String valueType, String key, Object value) async => false;
}

const HeartRateZoneTable _heartRateZone = HeartRateZoneTable(
  zone1: HeartRateZoneRange(lower: 95, upper: 130),
  zone2: HeartRateZoneRange(lower: 131, upper: 147),
  zone3: HeartRateZoneRange(lower: 148, upper: 164),
  zone4: HeartRateZoneRange(lower: 165, upper: 180),
  zone5: HeartRateZoneRange(lower: 181, upper: 190),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  test('Given 러너 프로필 When save 하면 Then SharedPreferences에 JSON으로 저장된다', () async {
    // Given
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final SharedPreferencesProfileRepository repository = SharedPreferencesProfileRepository(preferences);
    final RunnerProfile profile = RunnerProfile(
      birthYear: BirthYear(1996),
      gender: Gender.male,
      height: Height(170),
      weight: Weight(65),
      career: RunningCareer.beginner,
      weeklyFrequency: WeeklyFrequency(3),
      heartRateZone: _heartRateZone,
    );

    // When
    await repository.save(profile);

    // Then
    final String? stored = preferences.getString('runner_profile');
    expect(stored, isNotNull);
    expect(jsonDecode(stored!), <String, Object>{
      'birthYear': 1996,
      'gender': 'male',
      'height': 170,
      'weight': 65,
      'career': 'beginner',
      'weeklyFrequency': 3,
      'heartRateZone': <String, Object>{
        'zone1': <String, Object>{'lower': 95, 'upper': 130},
        'zone2': <String, Object>{'lower': 131, 'upper': 147},
        'zone3': <String, Object>{'lower': 148, 'upper': 164},
        'zone4': <String, Object>{'lower': 165, 'upper': 180},
        'zone5': <String, Object>{'lower': 181, 'upper': 190},
      },
    });
  });

  test('Given 저장된 러너 프로필이 없으면 When 프로필 stream 구독 후 save 하면 Then null 다음 저장된 RunnerProfile을 방출한다', () async {
    // Given
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final SharedPreferencesProfileRepository repository = SharedPreferencesProfileRepository(preferences);
    final RunnerProfile profile = RunnerProfile(
      birthYear: BirthYear(1996),
      gender: Gender.male,
      height: Height(170),
      weight: Weight(65),
      career: RunningCareer.beginner,
      weeklyFrequency: WeeklyFrequency(3),
      heartRateZone: _heartRateZone,
    );
    final Future<void> expectation = expectLater(repository.watchProfile(), emitsInOrder(<Object?>[null, profile]));

    // When
    await pumpEventQueue();
    await repository.save(profile);

    // Then
    await expectation;
  });

  test('Given 저장된 러너 프로필이 있으면 When 프로필 stream을 구독하면 Then 현재 RunnerProfile을 먼저 방출한다', () async {
    // Given
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final SharedPreferencesProfileRepository repository = SharedPreferencesProfileRepository(preferences);
    final RunnerProfile profile = RunnerProfile(
      birthYear: BirthYear(1996),
      gender: Gender.male,
      height: Height(170),
      weight: Weight(65),
      career: RunningCareer.beginner,
      weeklyFrequency: WeeklyFrequency(3),
      heartRateZone: _heartRateZone,
    );
    await repository.save(profile);

    // When
    final Future<RunnerProfile?> emitted = repository.watchProfile().first;

    // Then
    await expectLater(emitted, completion(profile));
  });

  test('Given SharedPreferences 저장이 실패하면 When save 하면 Then StateError를 던진다', () async {
    // Given
    SharedPreferencesStorePlatform.instance = _FailingSharedPreferencesStore();
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final SharedPreferencesProfileRepository repository = SharedPreferencesProfileRepository(preferences);
    final RunnerProfile profile = RunnerProfile(
      birthYear: BirthYear(1996),
      gender: Gender.male,
      height: Height(170),
      weight: Weight(65),
      career: RunningCareer.beginner,
      weeklyFrequency: WeeklyFrequency(3),
      heartRateZone: _heartRateZone,
    );

    // When & Then
    await expectLater(repository.save(profile), throwsStateError);
  });

  test('Given 저장된 러너 프로필 When load 하면 Then 저장된 RunnerProfile을 복원한다', () async {
    // Given
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final SharedPreferencesProfileRepository repository = SharedPreferencesProfileRepository(preferences);
    final RunnerProfile profile = RunnerProfile(
      birthYear: BirthYear(1996),
      gender: Gender.male,
      height: Height(170),
      weight: Weight(65),
      career: RunningCareer.beginner,
      weeklyFrequency: WeeklyFrequency(3),
      heartRateZone: _heartRateZone,
    );
    await repository.save(profile);

    // When
    final RunnerProfile? loaded = await repository.load();

    // Then
    expect(loaded, profile);
  });

  test('Given 저장된 러너 프로필이 없으면 When load 하면 Then null을 반환한다', () async {
    // Given
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final SharedPreferencesProfileRepository repository = SharedPreferencesProfileRepository(preferences);

    // When
    final RunnerProfile? loaded = await repository.load();

    // Then
    expect(loaded, isNull);
  });
}
