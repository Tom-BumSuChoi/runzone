import 'package:equatable/equatable.dart';

import 'heart_rate_zone_range.dart';

enum HeartRateZoneType { zone1, zone2, zone3, zone4, zone5 }

final class HeartRateZone extends Equatable {
  static const int _minimumHeartRate = 1;

  final HeartRateZoneRange zone1;
  final HeartRateZoneRange zone2;
  final HeartRateZoneRange zone3;
  final HeartRateZoneRange zone4;
  final HeartRateZoneRange zone5;

  const HeartRateZone({
    required this.zone1,
    required this.zone2,
    required this.zone3,
    required this.zone4,
    required this.zone5,
  });

  HeartRateZoneType getZoneType(int heartRate) {
    _validateHeartRate(heartRate);

    if (heartRate <= zone1.upper) {
      return HeartRateZoneType.zone1;
    }
    if (zone2.contains(heartRate)) {
      return HeartRateZoneType.zone2;
    }
    if (zone3.contains(heartRate)) {
      return HeartRateZoneType.zone3;
    }
    if (zone4.contains(heartRate)) {
      return HeartRateZoneType.zone4;
    }
    return HeartRateZoneType.zone5;
  }

  void _validateHeartRate(int heartRate) {
    if (heartRate < _minimumHeartRate) {
      throw ArgumentError.value(
        heartRate,
        'heartRate',
        'must be at least $_minimumHeartRate',
      );
    }
  }

  @override
  List<Object?> get props => [zone1, zone2, zone3, zone4, zone5];
}
