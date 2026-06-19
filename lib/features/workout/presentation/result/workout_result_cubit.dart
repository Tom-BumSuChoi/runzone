import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/workout_session.dart';

final class WorkoutResultCubit extends Cubit<WorkoutResultState> {
  WorkoutResultCubit({required this.session}) : super(const WorkoutResultState());

  final WorkoutSession session;
}

final class WorkoutResultState extends Equatable {
  const WorkoutResultState();

  @override
  List<Object?> get props => [];
}
