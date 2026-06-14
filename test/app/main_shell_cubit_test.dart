import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/app/cubit/main_shell_cubit.dart';

void main() {
  test('Given 메인 쉘 cubit을 만들면 When 초기 상태를 확인하면 Then 홈 탭이 선택되어 있다', () {
    final MainShellCubit cubit = MainShellCubit();

    expect(cubit.state, const MainShellState(selectedTab: MainShellTab.home));
  });

  blocTest<MainShellCubit, MainShellState>(
    'Given 메인 쉘 cubit이 있으면 When 플랜 탭을 선택하면 Then 선택 탭이 플랜으로 바뀐다',
    build: MainShellCubit.new,
    act: (cubit) => cubit.selectTab(MainShellTab.plan),
    expect: () => const [MainShellState(selectedTab: MainShellTab.plan)],
  );

  blocTest<MainShellCubit, MainShellState>(
    'Given 메인 쉘 cubit이 있으면 When 시작 슬롯을 선택하면 Then 선택 슬롯이 시작으로 바뀐다',
    build: MainShellCubit.new,
    act: (cubit) => cubit.selectTab(MainShellTab.start),
    expect: () => const [MainShellState(selectedTab: MainShellTab.start)],
  );
}
