import '../domain/heart_rate_measurement.dart';
import '../domain/heart_rate_monitor.dart';

final class MockHeartRateMonitor implements HeartRateMonitor {
  MockHeartRateMonitor({
    List<int> scenario = const [112, 118, 126, 131, 139, 150, 139, 126, 118],
    DateTime Function()? now,
  }) : _scenario = scenario,
       _now = now ?? DateTime.now {
    if (_scenario.isEmpty) {
      throw ArgumentError.value(scenario, 'scenario', 'must not be empty');
    }
  }

  final List<int> _scenario;
  final DateTime Function() _now;
  int _nextIndex = 0;

  @override
  HeartRateMeasurement measure() {
    final int beatsPerMinute = _scenario[_nextIndex % _scenario.length];
    _nextIndex += 1;

    return HeartRateMeasurement(beatsPerMinute: beatsPerMinute, measuredAt: _now());
  }
}
