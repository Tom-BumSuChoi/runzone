import '../domain/treadmill_device.dart';
import '../domain/treadmill_snapshot.dart';

final class MockTreadmillDevice implements TreadmillDevice {
  MockTreadmillDevice({
    List<TreadmillSnapshot> scenario = const [TreadmillSnapshot(speedKilometersPerHour: 6.0, isManualMode: false)],
  }) : _scenario = List<TreadmillSnapshot>.unmodifiable(scenario) {
    if (_scenario.isEmpty) {
      throw ArgumentError.value(scenario, 'scenario', 'must not be empty');
    }
    _currentSnapshot = _scenario.first;
  }

  static const double _speedStepKilometersPerHour = 0.1;

  final List<TreadmillSnapshot> _scenario;
  int _nextIndex = 0;
  late TreadmillSnapshot _currentSnapshot;

  @override
  TreadmillSnapshot read() {
    final snapshot = _scenario[_nextIndex % _scenario.length];
    _nextIndex += 1;
    _currentSnapshot = snapshot;
    return snapshot;
  }

  @override
  TreadmillSnapshot decreaseSpeed() {
    return _updateCurrentSnapshot(
      speedKilometersPerHour: _currentSnapshot.speedKilometersPerHour - _speedStepKilometersPerHour,
      isManualMode: true,
    );
  }

  @override
  TreadmillSnapshot increaseSpeed() {
    return _updateCurrentSnapshot(
      speedKilometersPerHour: _currentSnapshot.speedKilometersPerHour + _speedStepKilometersPerHour,
      isManualMode: true,
    );
  }

  @override
  TreadmillSnapshot enableManualMode() {
    return _updateCurrentSnapshot(isManualMode: true);
  }

  @override
  TreadmillSnapshot enableAutomaticMode() {
    return _updateCurrentSnapshot(isManualMode: false);
  }

  TreadmillSnapshot _updateCurrentSnapshot({double? speedKilometersPerHour, bool? isManualMode}) {
    _currentSnapshot = TreadmillSnapshot(
      speedKilometersPerHour: speedKilometersPerHour ?? _currentSnapshot.speedKilometersPerHour,
      isManualMode: isManualMode ?? _currentSnapshot.isManualMode,
    );
    return _currentSnapshot;
  }
}
