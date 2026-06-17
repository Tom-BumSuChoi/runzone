import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/heart_rate/data/mock_heart_rate_monitor.dart';
import 'package:runzone/features/heart_rate/domain/heart_rate_measurement.dart';

final class _FakeClock {
  _FakeClock(this._now);

  DateTime _now;

  DateTime call() => _now;

  void advance(Duration duration) {
    _now = _now.add(duration);
  }
}

void main() {
  test('Given mock 심박 모니터 When 측정하면 Then 시나리오 순서대로 심박 측정값을 반환한다', () {
    final DateTime measuredAt = DateTime(2026, 6, 17, 7);
    final _FakeClock clock = _FakeClock(measuredAt);
    final MockHeartRateMonitor monitor = MockHeartRateMonitor(
      scenario: const [118, 131],
      now: clock.call,
    );

    final HeartRateMeasurement firstMeasurement = monitor.measure();
    clock.advance(const Duration(seconds: 1));
    final HeartRateMeasurement secondMeasurement = monitor.measure();
    clock.advance(const Duration(seconds: 1));
    final HeartRateMeasurement thirdMeasurement = monitor.measure();

    expect([
      firstMeasurement,
      secondMeasurement,
      thirdMeasurement,
    ], [
      HeartRateMeasurement(beatsPerMinute: 118, measuredAt: measuredAt),
      HeartRateMeasurement(beatsPerMinute: 131, measuredAt: measuredAt.add(const Duration(seconds: 1))),
      HeartRateMeasurement(beatsPerMinute: 118, measuredAt: measuredAt.add(const Duration(seconds: 2))),
    ]);
  });
}
