import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../features/profile/domain/profile_repository.dart';
import '../../features/profile/domain/runner_profile.dart';

part 'app_state.dart';

final class AppCubit extends Cubit<AppState> {
  AppCubit({required ProfileRepository repository}) : super(const AppInitial()) {
    _profileSubscription = repository.watchProfile().listen(_emitProfileStatus);
  }

  late final StreamSubscription<RunnerProfile?> _profileSubscription;

  void _emitProfileStatus(RunnerProfile? profile) {
    if (isClosed) {
      return;
    }
    emit(AppReady(hasProfile: profile != null));
  }

  @override
  Future<void> close() async {
    await _profileSubscription.cancel();
    return super.close();
  }
}
