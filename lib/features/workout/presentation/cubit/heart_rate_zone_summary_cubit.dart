import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../profile/domain/profile_repository.dart';
import '../../../profile/domain/runner_profile.dart';

part 'heart_rate_zone_summary_state.dart';

final class HeartRateZoneSummaryCubit extends Cubit<HeartRateZoneSummaryState> {
  HeartRateZoneSummaryCubit(this._repository) : super(HeartRateZoneSummaryState.initial());

  final ProfileRepository _repository;

  Future<void> load() async {
    final RunnerProfile? profile = await _repository.load();
    if (profile == null) {
      return;
    }

    emit(HeartRateZoneSummaryState(zone: profile.heartRateZone));
  }
}
