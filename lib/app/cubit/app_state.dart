part of 'app_cubit.dart';

sealed class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

final class AppInitial extends AppState {
  const AppInitial();
}

final class AppReady extends AppState {
  const AppReady({required this.hasProfile});

  final bool hasProfile;

  @override
  List<Object?> get props => [hasProfile];
}
