import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone_calculator.dart';

part 'heart_rate_zone_setup_state.dart';

const HeartRateZoneCalculator _calculator = HeartRateZoneCalculator();

final class HeartRateZoneSetupCubit extends Cubit<HeartRateZoneSetupState> {
  HeartRateZoneSetupCubit() : super(const HeartRateZoneSetupState(age: _defaultAge));

  static const int _defaultAge = 30;

  void incrementAge() {
    final int next = state.age + 1;
    if (_calculator.isValidAge(next)) {
      emit(HeartRateZoneSetupState(age: next));
    }
  }

  void decrementAge() {
    final int previous = state.age - 1;
    if (_calculator.isValidAge(previous)) {
      emit(HeartRateZoneSetupState(age: previous));
    }
  }
}
