part of 'heart_rate_zone_setup_cubit.dart';

enum SetupStatus { editing, submitting, success, failure }

final class HeartRateZoneSetupState extends Equatable {
  const HeartRateZoneSetupState({
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.career,
    required this.weeklyFrequency,
    this.status = SetupStatus.editing,
  });

  factory HeartRateZoneSetupState.initial() => HeartRateZoneSetupState(
    age: 30,
    gender: Gender.male,
    height: Height(170),
    weight: Weight(65),
    career: RunningCareer.beginner,
    weeklyFrequency: WeeklyFrequency(3),
  );

  final int age;
  final Gender gender;
  final Height height;
  final Weight weight;
  final RunningCareer career;
  final WeeklyFrequency weeklyFrequency;
  final SetupStatus status;

  HeartRateZone get zone => _calculator.getHeartRateZone(age: age);

  HeartRateZoneSetupState copyWith({
    int? age,
    Gender? gender,
    Height? height,
    Weight? weight,
    RunningCareer? career,
    WeeklyFrequency? weeklyFrequency,
    SetupStatus? status,
  }) {
    return HeartRateZoneSetupState(
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      career: career ?? this.career,
      weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [age, gender, height, weight, career, weeklyFrequency, status];
}
