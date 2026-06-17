import 'package:equatable/equatable.dart';

final class HeartRateMeasurement extends Equatable {
  const HeartRateMeasurement({required this.beatsPerMinute, required this.measuredAt});

  final int beatsPerMinute;
  final DateTime measuredAt;

  @override
  List<Object?> get props => [beatsPerMinute, measuredAt];
}
