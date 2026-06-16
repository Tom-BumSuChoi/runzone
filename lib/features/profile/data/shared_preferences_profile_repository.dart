import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/profile_repository.dart';
import '../domain/runner_profile.dart';

final class SharedPreferencesProfileRepository implements ProfileRepository {
  SharedPreferencesProfileRepository(this._preferences);

  static const String _key = 'runner_profile';

  final SharedPreferences _preferences;
  final StreamController<RunnerProfile?> _profileController = StreamController<RunnerProfile?>.broadcast();

  @override
  Future<void> save(RunnerProfile profile) async {
    final String json = jsonEncode(<String, Object>{
      'birthYear': profile.birthYear.year,
      'gender': profile.gender.name,
      'height': profile.height.centimeters,
      'weight': profile.weight.kilograms,
      'career': profile.career.name,
      'weeklyFrequency': profile.weeklyFrequency.count,
      'heartRateZone': _heartRateZoneToJson(profile.heartRateZone),
    });

    final bool saved = await _preferences.setString(_key, json);
    if (!saved) {
      throw StateError('Failed to save runner profile.');
    }
    _profileController.add(profile);
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
      heartRateZone: _heartRateZoneFromJson(map['heartRateZone']),
    );
  }

  @override
  Stream<RunnerProfile?> watchProfile() async* {
    yield await load();
    yield* _profileController.stream;
  }

  Map<String, Object> _heartRateZoneToJson(HeartRateZoneTable zone) {
    return <String, Object>{
      'zone1': _heartRateZoneRangeToJson(zone.zone1),
      'zone2': _heartRateZoneRangeToJson(zone.zone2),
      'zone3': _heartRateZoneRangeToJson(zone.zone3),
      'zone4': _heartRateZoneRangeToJson(zone.zone4),
      'zone5': _heartRateZoneRangeToJson(zone.zone5),
    };
  }

  Map<String, Object> _heartRateZoneRangeToJson(HeartRateZoneRange range) {
    return <String, Object>{'lower': range.lower, 'upper': range.upper};
  }

  HeartRateZoneTable _heartRateZoneFromJson(Object? value) {
    final Map<String, Object?> map = value as Map<String, Object?>;

    return HeartRateZoneTable(
      zone1: _heartRateZoneRangeFromJson(map['zone1']),
      zone2: _heartRateZoneRangeFromJson(map['zone2']),
      zone3: _heartRateZoneRangeFromJson(map['zone3']),
      zone4: _heartRateZoneRangeFromJson(map['zone4']),
      zone5: _heartRateZoneRangeFromJson(map['zone5']),
    );
  }

  HeartRateZoneRange _heartRateZoneRangeFromJson(Object? value) {
    final Map<String, Object?> map = value as Map<String, Object?>;

    return HeartRateZoneRange(lower: map['lower'] as int, upper: map['upper'] as int);
  }
}
