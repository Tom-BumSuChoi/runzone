import 'dart:convert';

import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';
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
}
