import 'package:equatable/equatable.dart';
import 'package:runzone/features/workout/domain/birth_year.dart';
import 'package:runzone/features/workout/domain/gender.dart';
import 'package:runzone/features/workout/domain/height.dart';
import 'package:runzone/features/workout/domain/running_career.dart';
import 'package:runzone/features/workout/domain/weekly_frequency.dart';
import 'package:runzone/features/workout/domain/weight.dart';

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
