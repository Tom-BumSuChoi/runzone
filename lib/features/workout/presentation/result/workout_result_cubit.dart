import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/workout_plan.dart';
import '../../domain/workout_session.dart';

final class WorkoutResultCubit extends Cubit<WorkoutResultState> {
  WorkoutResultCubit({required this.session}) : super(WorkoutResultState.fromSession(session));

  final WorkoutSession session;
}

final class WorkoutResultState extends Equatable {
  const WorkoutResultState({required this.subtitle});

  factory WorkoutResultState.fromSession(WorkoutSession session) {
    return WorkoutResultState(subtitle: '${_planLabel(session.plan)} · ${_formatDate(session.startedAt)}');
  }

  final String subtitle;

  @override
  List<Object?> get props => [subtitle];
}

String _two(int value) => value.toString().padLeft(2, '0');

String _formatDate(DateTime date) => '${date.year}.${_two(date.month)}.${_two(date.day)}';

String _planLabel(WorkoutPlan plan) => switch (plan) {
  TargetZoneWorkoutPlan(:final targetHeartRateZone) => '존${targetHeartRateZone.index + 1} 지속주',
  IntervalWorkoutPlan() => '인터벌',
  FreeWorkoutPlan() => '자유 러닝',
};
