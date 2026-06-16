part of 'runner_profile_setup_cubit.dart';

enum RunnerProfileSetupStatus { editing, submitting, success, failure }

final class RunnerProfileSetupState extends Equatable {
  const RunnerProfileSetupState({
    required this.birthYear,
    required this.gender,
    required this.height,
    required this.weight,
    required this.career,
    required this.weeklyFrequency,
    this.status = RunnerProfileSetupStatus.editing,
  });

  factory RunnerProfileSetupState.initial() => RunnerProfileSetupState(
    birthYear: BirthYear(1996),
    gender: Gender.male,
    height: Height(170),
    weight: Weight(65),
    career: RunningCareer.beginner,
    weeklyFrequency: WeeklyFrequency(3),
  );

  final BirthYear birthYear;
  final Gender gender;
  final Height height;
  final Weight weight;
  final RunningCareer career;
  final WeeklyFrequency weeklyFrequency;
  final RunnerProfileSetupStatus status;

  int get age => DateTime.now().year - birthYear.year;

  HeartRateZoneTable get zone => _calculator.getHeartRateZone(age: age);

  RunnerProfileSetupState copyWith({
    BirthYear? birthYear,
    Gender? gender,
    Height? height,
    Weight? weight,
    RunningCareer? career,
    WeeklyFrequency? weeklyFrequency,
    RunnerProfileSetupStatus? status,
  }) {
    return RunnerProfileSetupState(
      birthYear: birthYear ?? this.birthYear,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      career: career ?? this.career,
      weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [birthYear, gender, height, weight, career, weeklyFrequency, status];
}
