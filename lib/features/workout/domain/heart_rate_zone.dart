import 'package:runzone/features/workout/domain/heart_rate_zone_range.dart';

final class HeartRateZone {
  final HeartRateZoneRange zone1;
  final HeartRateZoneRange zone2;
  final HeartRateZoneRange zone3;
  final HeartRateZoneRange zone4;
  final HeartRateZoneRange zone5;

  HeartRateZone({
    required this.zone1,
    required this.zone2,
    required this.zone3,
    required this.zone4,
    required this.zone5,
  });
}
