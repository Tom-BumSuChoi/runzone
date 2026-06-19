import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

final class WorkoutFeedbackCubit extends Cubit<WorkoutFeedbackState> {
  WorkoutFeedbackCubit() : super(const WorkoutFeedbackState());
}

final class WorkoutFeedbackState extends Equatable {
  const WorkoutFeedbackState();

  @override
  List<Object?> get props => const [];
}
