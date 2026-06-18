import 'workout_session_bloc.dart';

extension WorkoutSessionReadyStateExtension on WorkoutSessionState {
  WorkoutSessionReadyState get readyState {
    final state = this;
    if (state is WorkoutSessionReadyState) {
      return state;
    }

    return WorkoutSessionReadyState(heartRateZoneTable: heartRateZoneTable);
  }
}
