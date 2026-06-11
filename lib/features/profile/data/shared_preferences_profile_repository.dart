import 'dart:convert';

import 'package:runzone/features/profile/domain/birth_year.dart';
import 'package:runzone/features/profile/domain/gender.dart';
import 'package:runzone/features/profile/domain/height.dart';
import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';
import 'package:runzone/features/profile/domain/running_career.dart';
import 'package:runzone/features/profile/domain/weekly_frequency.dart';
import 'package:runzone/features/profile/domain/weight.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SharedPreferencesProfileRepository implements ProfileRepository {
  SharedPreferencesProfileRepository(this._preferences);

  static const String _key = 'runner_profile';

  final SharedPreferences _preferences;

  @override
  Future<void> save(RunnerProfile profile) async {
    final String json = jsonEncode(<String, Object>{
      'birthYear': profile.birthYear.year,
      'gender': profile.gender.name,
      'height': profile.height.centimeters,
      'weight': profile.weight.kilograms,
      'career': profile.career.name,
      'weeklyFrequency': profile.weeklyFrequency.count,
    });

    final bool saved = await _preferences.setString(_key, json);
    if (!saved) {
      throw StateError('Failed to save runner profile.');
    }
  }

  @override
  Future<RunnerProfile?> load() async {
    final String? json = _preferences.getString(_key);
    if (json == null) {
      return null;
    }

    final Map<String, Object?> map = jsonDecode(json) as Map<String, Object?>;

    return RunnerProfile(
      birthYear: BirthYear(map['birthYear'] as int),
      gender: Gender.values.byName(map['gender'] as String),
      height: Height(map['height'] as int),
      weight: Weight(map['weight'] as int),
      career: RunningCareer.values.byName(map['career'] as String),
      weeklyFrequency: WeeklyFrequency(map['weeklyFrequency'] as int),
    );
  }
}
