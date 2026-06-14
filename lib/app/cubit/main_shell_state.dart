part of 'main_shell_cubit.dart';

final class MainShellState extends Equatable {
  const MainShellState({required this.selectedTab});

  final MainShellTab selectedTab;

  @override
  List<Object?> get props => [selectedTab];
}
