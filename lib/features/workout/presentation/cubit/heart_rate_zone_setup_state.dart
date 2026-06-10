part of 'heart_rate_zone_setup_cubit.dart';

final class HeartRateZoneSetupState extends Equatable {
  const HeartRateZoneSetupState({
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.career,
    required this.weeklyFrequency,
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

  HeartRateZone get zone => _calculator.getHeartRateZone(age: age);

  HeartRateZoneSetupState copyWith({
    int? age,
    Gender? gender,
    Height? height,
    Weight? weight,
    RunningCareer? career,
    WeeklyFrequency? weeklyFrequency,
  }) {
    return HeartRateZoneSetupState(
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      career: career ?? this.career,
      weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
    );
  }

  @override
  List<Object?> get props => [age, gender, height, weight, career, weeklyFrequency];
}
