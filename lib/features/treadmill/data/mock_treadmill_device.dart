import '../domain/treadmill_device.dart';
import '../domain/treadmill_snapshot.dart';

final class MockTreadmillDevice implements TreadmillDevice {
  MockTreadmillDevice({
    List<TreadmillSnapshot> scenario = const [TreadmillSnapshot(speedKilometersPerHour: 6.0, isManualMode: false)],
  }) : _scenario = List<TreadmillSnapshot>.unmodifiable(scenario) {
    if (_scenario.isEmpty) {
      throw ArgumentError.value(scenario, 'scenario', 'must not be empty');
    }
  }

  final List<TreadmillSnapshot> _scenario;
  int _nextIndex = 0;

  @override
  TreadmillSnapshot read() {
    final TreadmillSnapshot snapshot = _scenario[_nextIndex % _scenario.length];
    _nextIndex += 1;
    return snapshot;
  }
}
