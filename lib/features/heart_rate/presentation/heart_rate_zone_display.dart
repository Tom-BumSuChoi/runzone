import 'package:flutter/material.dart';

import '../../../core/design_system/app_color_scheme.dart';
import '../domain/heart_rate_zone.dart';
import '../domain/heart_rate_zone_range.dart';

extension HeartRateZoneDisplay on HeartRateZone {
  String get label => switch (this) {
    HeartRateZone.zone1 => 'Z1 · 워밍업',
    HeartRateZone.zone2 => 'Z2 · 지구력',
    HeartRateZone.zone3 => 'Z3 · 유산소',
    HeartRateZone.zone4 => 'Z4 · 역치',
    HeartRateZone.zone5 => 'Z5 · 최대',
  };

  String get shortLabel => switch (this) {
    HeartRateZone.zone1 => 'Z1',
    HeartRateZone.zone2 => 'Z2',
    HeartRateZone.zone3 => 'Z3',
    HeartRateZone.zone4 => 'Z4',
    HeartRateZone.zone5 => 'Z5',
  };

  Color color(ColorScheme colorScheme) => switch (this) {
    HeartRateZone.zone1 => colorScheme.zoneOne,
    HeartRateZone.zone2 => colorScheme.zoneTwo,
    HeartRateZone.zone3 => colorScheme.zoneThree,
    HeartRateZone.zone4 => colorScheme.zoneFour,
    HeartRateZone.zone5 => colorScheme.zoneFive,
  };
}

extension HeartRateZoneTableDisplay on HeartRateZoneTable {
  HeartRateZoneRange range(HeartRateZone zone) => switch (zone) {
    HeartRateZone.zone1 => zone1,
    HeartRateZone.zone2 => zone2,
    HeartRateZone.zone3 => zone3,
    HeartRateZone.zone4 => zone4,
    HeartRateZone.zone5 => zone5,
  };
}
