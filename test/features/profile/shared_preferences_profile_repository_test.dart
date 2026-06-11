import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/profile/data/shared_preferences_profile_repository.dart';
import 'package:runzone/features/profile/domain/birth_year.dart';
import 'package:runzone/features/profile/domain/gender.dart';
import 'package:runzone/features/profile/domain/height.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';
import 'package:runzone/features/profile/domain/running_career.dart';
import 'package:runzone/features/profile/domain/weekly_frequency.dart';
import 'package:runzone/features/profile/domain/weight.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

final class _FailingSharedPreferencesStore extends InMemorySharedPreferencesStore {
  _FailingSharedPreferencesStore() : super.empty();

  @override
  Future<bool> setValue(String valueType, String key, Object value) async => false;
}

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
    });
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
    );

    // When & Then
    await expectLater(repository.save(profile), throwsStateError);
  });
}
