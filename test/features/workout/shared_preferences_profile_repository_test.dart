import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/workout/data/shared_preferences_profile_repository.dart';
import 'package:runzone/features/workout/domain/gender.dart';
import 'package:runzone/features/workout/domain/height.dart';
import 'package:runzone/features/workout/domain/runner_profile.dart';
import 'package:runzone/features/workout/domain/running_career.dart';
import 'package:runzone/features/workout/domain/weekly_frequency.dart';
import 'package:runzone/features/workout/domain/weight.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  test('Given 러너 프로필 When save 하면 Then SharedPreferences에 JSON으로 저장된다', () async {
    // Given
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final SharedPreferencesProfileRepository repository = SharedPreferencesProfileRepository(preferences);
    final RunnerProfile profile = RunnerProfile(
      age: 30,
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
      'age': 30,
      'gender': 'male',
      'height': 170,
      'weight': 65,
      'career': 'beginner',
      'weeklyFrequency': 3,
    });
  });
}
