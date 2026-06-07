final class HeartRateZoneRange {
  final int lower;
  final int upper;

  HeartRateZoneRange({required this.lower, required this.upper});

  bool contains(int heartRate) {
    return heartRate >= lower && heartRate <= upper;
  }
}
