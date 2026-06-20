import 'treadmill_snapshot.dart';

abstract interface class TreadmillDevice {
  TreadmillSnapshot read();

  TreadmillSnapshot decreaseSpeed();

  TreadmillSnapshot increaseSpeed();

  TreadmillSnapshot enableManualMode();

  TreadmillSnapshot enableAutomaticMode();
}
