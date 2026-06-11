import 'package:equatable/equatable.dart';
import 'package:runzone/features/profile/domain/birth_year.dart';
import 'package:runzone/features/profile/domain/gender.dart';
import 'package:runzone/features/profile/domain/height.dart';
import 'package:runzone/features/profile/domain/running_career.dart';
import 'package:runzone/features/profile/domain/weekly_frequency.dart';
import 'package:runzone/features/profile/domain/weight.dart';

final class RunnerProfile extends Equatable {
  const RunnerProfile({
    required this.birthYear,
    required this.gender,
    required this.height,
    required this.weight,
    required this.career,
    required this.weeklyFrequency,
  });

  final BirthYear birthYear;
  final Gender gender;
  final Height height;
  final Weight weight;
  final RunningCareer career;
  final WeeklyFrequency weeklyFrequency;

  @override
  List<Object?> get props => [birthYear, gender, height, weight, career, weeklyFrequency];
}
