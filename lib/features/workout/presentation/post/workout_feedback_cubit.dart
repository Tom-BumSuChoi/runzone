import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

final class WorkoutFeedbackCubit extends Cubit<WorkoutFeedbackState> {
  WorkoutFeedbackCubit() : super(const WorkoutFeedbackState());

  void perceivedExertionSelected(int perceivedExertion) {
    if (perceivedExertion < WorkoutFeedbackState.minimumPerceivedExertion ||
        perceivedExertion > WorkoutFeedbackState.maximumPerceivedExertion) {
      return;
    }

    emit(WorkoutFeedbackState(perceivedExertion: perceivedExertion, mood: state.mood, note: state.note));
  }

  void moodSelected(WorkoutFeedbackMood mood) {
    emit(WorkoutFeedbackState(perceivedExertion: state.perceivedExertion, mood: mood, note: state.note));
  }

  void noteChanged(String note) {
    emit(WorkoutFeedbackState(perceivedExertion: state.perceivedExertion, mood: state.mood, note: note));
  }

  void saveButtonTapped() {}

  void skipButtonTapped() {}
}

enum WorkoutFeedbackMood { hard, neutral, good, great }

final class WorkoutFeedbackState extends Equatable {
  const WorkoutFeedbackState({this.perceivedExertion = 4, this.mood = WorkoutFeedbackMood.good, this.note = ''});

  static const minimumPerceivedExertion = 1;
  static const maximumPerceivedExertion = 10;

  final int perceivedExertion;
  final WorkoutFeedbackMood mood;
  final String note;

  @override
  List<Object?> get props => [perceivedExertion, mood, note];
}
