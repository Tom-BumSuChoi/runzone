import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

final class WorkoutFeedbackCubit extends Cubit<WorkoutFeedbackState> {
  WorkoutFeedbackCubit() : super(const WorkoutFeedbackState());

  void perceivedExertionSelected(int perceivedExertion) {
    if (perceivedExertion < WorkoutFeedbackState.minimumPerceivedExertion ||
        perceivedExertion > WorkoutFeedbackState.maximumPerceivedExertion) {
      return;
    }

    emit(WorkoutFeedbackState(perceivedExertion: perceivedExertion, mood: state.mood));
  }

  void moodSelected(WorkoutFeedbackMood mood) {
    emit(WorkoutFeedbackState(perceivedExertion: state.perceivedExertion, mood: mood));
  }
}

enum WorkoutFeedbackMood { hard, neutral, good, great }

final class WorkoutFeedbackState extends Equatable {
  const WorkoutFeedbackState({this.perceivedExertion = 4, this.mood = WorkoutFeedbackMood.good});

  static const minimumPerceivedExertion = 1;
  static const maximumPerceivedExertion = 10;

  final int perceivedExertion;
  final WorkoutFeedbackMood mood;

  @override
  List<Object?> get props => [perceivedExertion, mood];
}
