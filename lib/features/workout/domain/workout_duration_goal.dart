import 'package:equatable/equatable.dart';

final class WorkoutDurationGoal extends Equatable {
  const WorkoutDurationGoal({required this.minutes});

  static const stepMinutes = 5;
  static const minimumMinutes = 5;
  static const maximumMinutes = 995;
  static const initialMinutes = 40;

  final int minutes;

  factory WorkoutDurationGoal.initial() {
    return const WorkoutDurationGoal(minutes: initialMinutes);
  }

  WorkoutDurationGoal increase() {
    final nextMinutes = minutes + stepMinutes;

    return WorkoutDurationGoal(minutes: nextMinutes > maximumMinutes ? maximumMinutes : nextMinutes);
  }

  WorkoutDurationGoal decrease() {
    final nextMinutes = minutes - stepMinutes;

    return WorkoutDurationGoal(minutes: nextMinutes < minimumMinutes ? minimumMinutes : nextMinutes);
  }

  @override
  List<Object?> get props => [minutes];
}
