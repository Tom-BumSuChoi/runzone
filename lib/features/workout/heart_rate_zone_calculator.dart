final class HeartRateZoneCalculator {
  const HeartRateZoneCalculator();

  int maxHeartRate({required int age}) {
    return (208 - 0.7 * age).round();
  }
}
