import 'package:equatable/equatable.dart';

import 'heart_rate_zone_range.dart';

enum HeartRateZone {
  zone1,
  zone2,
  zone3,
  zone4,
  zone5;

  HeartRateZone increase() {
    final nextIndex = index + 1;

    if (nextIndex >= HeartRateZone.values.length) {
      return this;
    }

    return HeartRateZone.values[nextIndex];
  }

  HeartRateZone decrease() {
    final nextIndex = index - 1;

    if (nextIndex < 0) {
      return this;
    }

    return HeartRateZone.values[nextIndex];
  }
}

final class HeartRateZoneTable extends Equatable {
  static const int minimumZoneWidth = 5;
  static const int _minimumHeartRate = 1;

  final HeartRateZoneRange zone1;
  final HeartRateZoneRange zone2;
  final HeartRateZoneRange zone3;
  final HeartRateZoneRange zone4;
  final HeartRateZoneRange zone5;

  const HeartRateZoneTable({
    required this.zone1,
    required this.zone2,
    required this.zone3,
    required this.zone4,
    required this.zone5,
  });

  HeartRateZone getZoneType(int heartRate) {
    _validateHeartRate(heartRate);

    if (heartRate <= zone1.upper) {
      return HeartRateZone.zone1;
    }
    if (zone2.contains(heartRate)) {
      return HeartRateZone.zone2;
    }
    if (zone3.contains(heartRate)) {
      return HeartRateZone.zone3;
    }
    if (zone4.contains(heartRate)) {
      return HeartRateZone.zone4;
    }
    return HeartRateZone.zone5;
  }

  void _validateHeartRate(int heartRate) {
    if (heartRate < _minimumHeartRate) {
      throw ArgumentError.value(heartRate, 'heartRate', 'must be at least $_minimumHeartRate');
    }
  }

  @override
  List<Object?> get props => [zone1, zone2, zone3, zone4, zone5];
}
