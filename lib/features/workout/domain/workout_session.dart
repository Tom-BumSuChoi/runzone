import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../heart_rate/domain/heart_rate_measurement.dart';
import '../../heart_rate/domain/heart_rate_zone.dart';

@immutable
final class WorkoutSession extends Equatable {
  const WorkoutSession({
    required this.startedAt,
    required this.elapsed,
    required this.heartRateZoneTable,
    this.endedAt,
    this.heartRateMeasurements = const [],
  });

  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration elapsed;
  final HeartRateZoneTable heartRateZoneTable;
  final List<HeartRateMeasurement> heartRateMeasurements;

  HeartRateMeasurement? get latestHeartRateMeasurement {
    if (heartRateMeasurements.isEmpty) {
      return null;
    }
    return heartRateMeasurements.last;
  }

  HeartRateZone? get latestHeartRateZone {
    final HeartRateMeasurement? measurement = latestHeartRateMeasurement;
    if (measurement == null) {
      return null;
    }
    return heartRateZoneTable.getZoneType(measurement.beatsPerMinute);
  }

  WorkoutSession copyWith({DateTime? endedAt, Duration? elapsed, List<HeartRateMeasurement>? heartRateMeasurements}) {
    return WorkoutSession(
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
      elapsed: elapsed ?? this.elapsed,
      heartRateZoneTable: heartRateZoneTable,
      heartRateMeasurements: heartRateMeasurements ?? this.heartRateMeasurements,
    );
  }

  WorkoutSession recordHeartRate(HeartRateMeasurement measurement) {
    return copyWith(heartRateMeasurements: [...heartRateMeasurements, measurement]);
  }

  WorkoutSession finish({required DateTime endedAt, required Duration elapsed}) {
    return copyWith(endedAt: endedAt, elapsed: elapsed);
  }

  @override
  List<Object?> get props => [startedAt, endedAt, elapsed, heartRateZoneTable, heartRateMeasurements];
}
