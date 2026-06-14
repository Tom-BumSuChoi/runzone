import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../features/profile/domain/profile_repository.dart';

part 'app_state.dart';

final class AppCubit extends Cubit<AppState> {
  AppCubit({required this._repository}) : super(const AppInitial()) {
    _initialize();
  }

  final ProfileRepository _repository;

  Future<void> _initialize() async {
    final profile = await _repository.load();
    emit(AppReady(hasProfile: profile != null));
  }
}
