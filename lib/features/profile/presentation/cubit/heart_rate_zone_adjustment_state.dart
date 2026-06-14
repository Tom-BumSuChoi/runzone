part of 'heart_rate_zone_adjustment_cubit.dart';

sealed class HeartRateZoneAdjustmentState extends Equatable {
  const HeartRateZoneAdjustmentState();

  @override
  List<Object?> get props => const [];
}

final class HeartRateZoneAdjustmentLoading extends HeartRateZoneAdjustmentState {
  const HeartRateZoneAdjustmentLoading();
}

final class HeartRateZoneAdjustmentEditing extends HeartRateZoneAdjustmentState {
  const HeartRateZoneAdjustmentEditing({required this.zone});

  final HeartRateZone zone;

  int get zoneOneUpperBound => zone.zone1.upper;

  int get zoneTwoUpperBound => zone.zone2.upper;

  int get zoneThreeUpperBound => zone.zone3.upper;

  int get zoneFourUpperBound => zone.zone4.upper;

  int get minimumHeartRate => zone.zone1.lower;

  int get maximumHeartRate => zone.zone5.upper;

  int get zoneOneMinimum => minimumHeartRate;

  int get zoneOneMaximum => zoneTwoUpperBound - HeartRateZone.minimumZoneWidth;

  int get zoneTwoMinimum => zoneOneUpperBound + HeartRateZone.minimumZoneWidth;

  int get zoneTwoMaximum => zoneThreeUpperBound - HeartRateZone.minimumZoneWidth;

  int get zoneThreeMinimum => zoneTwoUpperBound + HeartRateZone.minimumZoneWidth;

  int get zoneThreeMaximum => zoneFourUpperBound - HeartRateZone.minimumZoneWidth;

  int get zoneFourMinimum => zoneThreeUpperBound + HeartRateZone.minimumZoneWidth;

  int get zoneFourMaximum => maximumHeartRate - HeartRateZone.minimumZoneWidth;

  double get zoneOneHeightFactor => _heightFactor(zoneOneUpperBound);

  double get zoneTwoHeightFactor => _heightFactor(zoneTwoUpperBound);

  double get zoneThreeHeightFactor => _heightFactor(zoneThreeUpperBound);

  double get zoneFourHeightFactor => _heightFactor(zoneFourUpperBound);

  double get zoneFiveHeightFactor => _heightFactor(maximumHeartRate);

  HeartRateZoneAdjustmentEditing copyWith({HeartRateZone? zone}) {
    return HeartRateZoneAdjustmentEditing(zone: zone ?? this.zone);
  }

  double _heightFactor(int upperBound) {
    return (upperBound - minimumHeartRate) / (maximumHeartRate - minimumHeartRate);
  }

  @override
  List<Object?> get props => [zone];
}
