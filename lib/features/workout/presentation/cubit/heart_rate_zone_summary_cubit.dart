import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone.dart';
import 'package:runzone/features/workout/domain/heart_rate_zone_calculator.dart';

part 'heart_rate_zone_summary_state.dart';

const HeartRateZoneCalculator _calculator = HeartRateZoneCalculator();

final class HeartRateZoneSummaryCubit extends Cubit<HeartRateZoneSummaryState> {
  HeartRateZoneSummaryCubit(this._repository) : super(HeartRateZoneSummaryState.initial());

  final ProfileRepository _repository;

  Future<void> load() async {
    final RunnerProfile? profile = await _repository.load();
    if (profile == null) {
      return;
    }

    final int age = DateTime.now().year - profile.birthYear.year;
    emit(HeartRateZoneSummaryState(zone: _calculator.getHeartRateZone(age: age)));
  }
}
