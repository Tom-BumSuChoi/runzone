import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:runzone/features/workout/domain/gender.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone_calculator.dart';
import 'package:runzone/features/workout/domain/height.dart';
import 'package:runzone/features/workout/domain/profile_repository.dart';
import 'package:runzone/features/workout/domain/runner_profile.dart';
import 'package:runzone/features/workout/domain/running_career.dart';
import 'package:runzone/features/workout/domain/weekly_frequency.dart';
import 'package:runzone/features/workout/domain/weight.dart';

part 'heart_rate_zone_setup_state.dart';

const HeartRateZoneCalculator _calculator = HeartRateZoneCalculator();

final class HeartRateZoneSetupCubit extends Cubit<HeartRateZoneSetupState> {
  HeartRateZoneSetupCubit(this._repository) : super(HeartRateZoneSetupState.initial());

  final ProfileRepository _repository;

  void incrementAge() {
    final int next = state.age + 1;
    if (_calculator.isValidAge(next)) {
      emit(state.copyWith(age: next));
    }
  }

  void decrementAge() {
    final int previous = state.age - 1;
    if (_calculator.isValidAge(previous)) {
      emit(state.copyWith(age: previous));
    }
  }

  void changeGender(Gender gender) => emit(state.copyWith(gender: gender));

  void changeHeight(int centimeters) => emit(state.copyWith(height: Height(centimeters)));

  void changeWeight(int kilograms) => emit(state.copyWith(weight: Weight(kilograms)));

  void changeCareer(RunningCareer career) => emit(state.copyWith(career: career));

  void changeWeeklyFrequency(int count) => emit(state.copyWith(weeklyFrequency: WeeklyFrequency(count)));

  Future<void> complete() async {
    if (state.status == SetupStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: SetupStatus.submitting));
    try {
      await _repository.save(
        RunnerProfile(
          age: state.age,
          gender: state.gender,
          height: state.height,
          weight: state.weight,
          career: state.career,
          weeklyFrequency: state.weeklyFrequency,
        ),
      );
      emit(state.copyWith(status: SetupStatus.success));
    } catch (_) {
      emit(state.copyWith(status: SetupStatus.failure));
    }
  }
}
