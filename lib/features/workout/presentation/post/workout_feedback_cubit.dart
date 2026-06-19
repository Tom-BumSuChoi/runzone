import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

final class WorkoutFeedbackCubit extends Cubit<WorkoutFeedbackState> {
  WorkoutFeedbackCubit() : super(const WorkoutFeedbackState());

  void perceivedExertionSelected(int perceivedExertion) {
    if (perceivedExertion < WorkoutFeedbackState.minimumPerceivedExertion ||
        perceivedExertion > WorkoutFeedbackState.maximumPerceivedExertion) {
      return;
    }

    emit(WorkoutFeedbackState(perceivedExertion: perceivedExertion));
  }
}

final class WorkoutFeedbackState extends Equatable {
  const WorkoutFeedbackState({this.perceivedExertion = 4});

  static const minimumPerceivedExertion = 1;
  static const maximumPerceivedExertion = 10;

  final int perceivedExertion;

  @override
  List<Object?> get props => [perceivedExertion];
}
