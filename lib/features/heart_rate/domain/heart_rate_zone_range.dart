import 'package:equatable/equatable.dart';

final class HeartRateZoneRange extends Equatable {
  final int lower;
  final int upper;

  const HeartRateZoneRange({required this.lower, required this.upper});

  bool contains(int heartRate) {
    return heartRate >= lower && heartRate <= upper;
  }

  @override
  List<Object?> get props => [lower, upper];
}
