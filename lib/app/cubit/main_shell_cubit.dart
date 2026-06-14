import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_shell_state.dart';

enum MainShellTab { home, plan, start, stats, myPage }

final class MainShellCubit extends Cubit<MainShellState> {
  MainShellCubit() : super(const MainShellState(selectedTab: MainShellTab.home));

  void selectTab(MainShellTab tab) {
    if (state.selectedTab == tab) {
      return;
    }

    emit(MainShellState(selectedTab: tab));
  }
}
