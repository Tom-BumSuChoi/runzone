import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../workout/domain/heart_rate_zone.dart';
import '../../../workout/domain/heart_rate_zone_calculator.dart';
import '../../domain/birth_year.dart';
import '../../domain/gender.dart';
import '../../domain/height.dart';
import '../../domain/profile_repository.dart';
import '../../domain/runner_profile.dart';
import '../../domain/running_career.dart';
import '../../domain/weekly_frequency.dart';
import '../../domain/weight.dart';

part 'runner_profile_setup_state.dart';

const HeartRateZoneCalculator _calculator = HeartRateZoneCalculator();

final class RunnerProfileSetupCubit extends Cubit<RunnerProfileSetupState> {
  RunnerProfileSetupCubit(this._repository) : super(RunnerProfileSetupState.initial());

  final ProfileRepository _repository;

  void incrementBirthYear() => emit(state.copyWith(birthYear: state.birthYear.incremented()));

  void decrementBirthYear() => emit(state.copyWith(birthYear: state.birthYear.decremented()));

  void changeGender(Gender gender) => emit(state.copyWith(gender: gender));

  void incrementHeight() => emit(state.copyWith(height: state.height.incremented()));

  void decrementHeight() => emit(state.copyWith(height: state.height.decremented()));

  void incrementWeight() => emit(state.copyWith(weight: state.weight.incremented()));

  void decrementWeight() => emit(state.copyWith(weight: state.weight.decremented()));

  void changeCareer(RunningCareer career) => emit(state.copyWith(career: career));

  void changeWeeklyFrequency(int count) => emit(state.copyWith(weeklyFrequency: WeeklyFrequency(count)));

  Future<void> complete() async {
    if (state.status == RunnerProfileSetupStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: RunnerProfileSetupStatus.submitting));
    try {
      await _repository.save(
        RunnerProfile(
          birthYear: state.birthYear,
          gender: state.gender,
          height: state.height,
          weight: state.weight,
          career: state.career,
          weeklyFrequency: state.weeklyFrequency,
          heartRateZone: state.zone,
        ),
      );
      emit(state.copyWith(status: RunnerProfileSetupStatus.success));
    } catch (_) {
      emit(state.copyWith(status: RunnerProfileSetupStatus.failure));
    }
  }
}
