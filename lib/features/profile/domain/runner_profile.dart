import 'package:equatable/equatable.dart';

import '../../workout/domain/heart_rate_zone.dart';
import 'birth_year.dart';
import 'gender.dart';
import 'height.dart';
import 'running_career.dart';
import 'weekly_frequency.dart';
import 'weight.dart';

export '../../workout/domain/heart_rate_zone.dart';
export '../../workout/domain/heart_rate_zone_range.dart';
export 'birth_year.dart';
export 'gender.dart';
export 'height.dart';
export 'running_career.dart';
export 'weekly_frequency.dart';
export 'weight.dart';

final class RunnerProfile extends Equatable {
  const RunnerProfile({
    required this.birthYear,
    required this.gender,
    required this.height,
    required this.weight,
    required this.career,
    required this.weeklyFrequency,
    required this.heartRateZone,
  });

  final BirthYear birthYear;
  final Gender gender;
  final Height height;
  final Weight weight;
  final RunningCareer career;
  final WeeklyFrequency weeklyFrequency;
  final HeartRateZoneTable heartRateZone;

  RunnerProfile copyWith({HeartRateZoneTable? heartRateZone}) {
    return RunnerProfile(
      birthYear: birthYear,
      gender: gender,
      height: height,
      weight: weight,
      career: career,
      weeklyFrequency: weeklyFrequency,
      heartRateZone: heartRateZone ?? this.heartRateZone,
    );
  }

  @override
  List<Object?> get props => [birthYear, gender, height, weight, career, weeklyFrequency, heartRateZone];
}
