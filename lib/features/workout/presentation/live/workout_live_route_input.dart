import '../../domain/workout_session.dart';

final class WorkoutLiveRouteInput {
  const WorkoutLiveRouteInput({required this.session, required this.isAutoPaceEnabled});

  final WorkoutSession session;
  final bool isAutoPaceEnabled;
}
