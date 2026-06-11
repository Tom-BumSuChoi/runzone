import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:runzone/features/profile/domain/birth_year.dart';
import 'package:runzone/features/profile/domain/gender.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone_calculator.dart';
import 'package:runzone/features/profile/domain/height.dart';
import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';
import 'package:runzone/features/profile/domain/running_career.dart';
import 'package:runzone/features/profile/domain/weekly_frequency.dart';
import 'package:runzone/features/profile/domain/weight.dart';

part 'heart_rate_zone_setup_state.dart';

const HeartRateZoneCalculator _calculator = HeartRateZoneCalculator();

final class HeartRateZoneSetupCubit extends Cubit<HeartRateZoneSetupState> {
  HeartRateZoneSetupCubit(this._repository) : super(HeartRateZoneSetupState.initial());

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
    if (state.status == SetupStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: SetupStatus.submitting));
    try {
      await _repository.save(
        RunnerProfile(
          birthYear: state.birthYear,
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
