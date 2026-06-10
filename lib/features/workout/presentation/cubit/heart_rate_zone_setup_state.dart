part of 'heart_rate_zone_setup_cubit.dart';

final class HeartRateZoneSetupState extends Equatable {
  const HeartRateZoneSetupState({required this.age});

  final int age;

  HeartRateZone get zone => _calculator.getHeartRateZone(age: age);

  @override
  List<Object?> get props => [age];
}
