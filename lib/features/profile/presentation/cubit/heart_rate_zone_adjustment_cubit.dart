import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../heart_rate/domain/heart_rate_zone_calculator.dart';
import '../../domain/profile_repository.dart';
import '../../domain/runner_profile.dart';

part 'heart_rate_zone_adjustment_state.dart';

const HeartRateZoneCalculator _calculator = HeartRateZoneCalculator();

final class HeartRateZoneAdjustmentCubit extends Cubit<HeartRateZoneAdjustmentState> {
  HeartRateZoneAdjustmentCubit(this._repository) : super(const HeartRateZoneAdjustmentLoading()) {
    _load();
  }

  final ProfileRepository _repository;
  RunnerProfile? _profile;

  Future<void> _load() async {
    final RunnerProfile? profile = await _repository.load();
    if (isClosed) {
      return;
    }
    if (profile == null) {
      return;
    }

    _profile = profile;
    emit(HeartRateZoneAdjustmentEditing(zone: profile.heartRateZone));
  }

  Future<void> updateZoneOneUpperBound(int value) async {
    final HeartRateZoneAdjustmentEditing? editingState = _editingState;
    if (editingState == null) {
      return;
    }

    final nextValue = _clamp(value, editingState.zoneOneMinimum, editingState.zoneOneMaximum);
    if (nextValue == editingState.zoneOneUpperBound) {
      return;
    }

    await _emitAndSave(editingState, _zoneWith(editingState, zoneOneUpperBound: nextValue));
  }

  Future<void> updateZoneTwoUpperBound(int value) async {
    final HeartRateZoneAdjustmentEditing? editingState = _editingState;
    if (editingState == null) {
      return;
    }

    final nextValue = _clamp(value, editingState.zoneTwoMinimum, editingState.zoneTwoMaximum);
    if (nextValue == editingState.zoneTwoUpperBound) {
      return;
    }

    await _emitAndSave(editingState, _zoneWith(editingState, zoneTwoUpperBound: nextValue));
  }

  Future<void> updateZoneThreeUpperBound(int value) async {
    final HeartRateZoneAdjustmentEditing? editingState = _editingState;
    if (editingState == null) {
      return;
    }

    final nextValue = _clamp(value, editingState.zoneThreeMinimum, editingState.zoneThreeMaximum);
    if (nextValue == editingState.zoneThreeUpperBound) {
      return;
    }

    await _emitAndSave(editingState, _zoneWith(editingState, zoneThreeUpperBound: nextValue));
  }

  Future<void> updateZoneFourUpperBound(int value) async {
    final HeartRateZoneAdjustmentEditing? editingState = _editingState;
    if (editingState == null) {
      return;
    }

    final nextValue = _clamp(value, editingState.zoneFourMinimum, editingState.zoneFourMaximum);
    if (nextValue == editingState.zoneFourUpperBound) {
      return;
    }

    await _emitAndSave(editingState, _zoneWith(editingState, zoneFourUpperBound: nextValue));
  }

  Future<void> restoreProfileZones() async {
    final HeartRateZoneAdjustmentEditing? editingState = _editingState;
    final RunnerProfile? profile = _profile;
    if (editingState == null || profile == null) {
      return;
    }

    final int age = DateTime.now().year - profile.birthYear.year;
    final HeartRateZoneTable profileZone = _calculator.getHeartRateZone(age: age);
    if (profileZone == editingState.zone) {
      return;
    }

    await _emitAndSave(editingState, profileZone);
  }

  int _clamp(int value, int minimum, int maximum) => value.clamp(minimum, maximum).toInt();

  HeartRateZoneAdjustmentEditing? get _editingState {
    final HeartRateZoneAdjustmentState currentState = state;
    return currentState is HeartRateZoneAdjustmentEditing ? currentState : null;
  }

  HeartRateZoneTable _zoneWith(
    HeartRateZoneAdjustmentEditing editingState, {
    int? zoneOneUpperBound,
    int? zoneTwoUpperBound,
    int? zoneThreeUpperBound,
    int? zoneFourUpperBound,
  }) {
    final int nextZoneOneUpperBound = zoneOneUpperBound ?? editingState.zoneOneUpperBound;
    final int nextZoneTwoUpperBound = zoneTwoUpperBound ?? editingState.zoneTwoUpperBound;
    final int nextZoneThreeUpperBound = zoneThreeUpperBound ?? editingState.zoneThreeUpperBound;
    final int nextZoneFourUpperBound = zoneFourUpperBound ?? editingState.zoneFourUpperBound;

    return HeartRateZoneTable(
      zone1: HeartRateZoneRange(lower: editingState.minimumHeartRate, upper: nextZoneOneUpperBound),
      zone2: HeartRateZoneRange(lower: nextZoneOneUpperBound + 1, upper: nextZoneTwoUpperBound),
      zone3: HeartRateZoneRange(lower: nextZoneTwoUpperBound + 1, upper: nextZoneThreeUpperBound),
      zone4: HeartRateZoneRange(lower: nextZoneThreeUpperBound + 1, upper: nextZoneFourUpperBound),
      zone5: HeartRateZoneRange(lower: nextZoneFourUpperBound + 1, upper: editingState.maximumHeartRate),
    );
  }

  Future<void> _emitAndSave(HeartRateZoneAdjustmentEditing editingState, HeartRateZoneTable zone) async {
    final HeartRateZoneAdjustmentEditing nextState = editingState.copyWith(zone: zone);
    emit(nextState);

    final RunnerProfile? profile = _profile;
    if (profile == null) {
      return;
    }

    final RunnerProfile nextProfile = profile.copyWith(heartRateZone: nextState.zone);
    _profile = nextProfile;
    await _repository.save(nextProfile);
  }
}
