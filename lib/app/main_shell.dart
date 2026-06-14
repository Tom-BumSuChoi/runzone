import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runzone/app/cubit/main_shell_cubit.dart';
import 'package:runzone/core/design_system/widgets/navigation/run_zone_bottom_navigation.dart';

extension _MainShellTabLabel on MainShellTab {
  String get label => switch (this) {
    MainShellTab.home => '홈',
    MainShellTab.plan => '플랜',
    MainShellTab.start => '시작',
    MainShellTab.stats => '기록',
    MainShellTab.myPage => '마이페이지',
  };
}

final class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => MainShellCubit(), child: const _MainShellView());
  }
}

final class _MainShellView extends StatelessWidget {
  const _MainShellView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainShellCubit, MainShellState>(
      builder: (context, state) {
        final cubit = context.read<MainShellCubit>();
        return Scaffold(
          body: Center(child: Text(state.selectedTab.label)),
          bottomNavigationBar: RunZoneBottomNavigation(
            items: [
              RunZoneBottomNavigationItem(
                label: MainShellTab.home.label,
                iconAsset: 'assets/icons/home.svg',
                isSelected: state.selectedTab == MainShellTab.home,
                onTap: () => cubit.selectTab(MainShellTab.home),
              ),
              RunZoneBottomNavigationItem(
                label: MainShellTab.plan.label,
                iconAsset: 'assets/icons/calendar.svg',
                isSelected: state.selectedTab == MainShellTab.plan,
                onTap: () => cubit.selectTab(MainShellTab.plan),
              ),
              RunZoneBottomNavigationStartButton(onTap: () => cubit.selectTab(MainShellTab.start)),
              RunZoneBottomNavigationItem(
                label: MainShellTab.stats.label,
                iconAsset: 'assets/icons/activity.svg',
                isSelected: state.selectedTab == MainShellTab.stats,
                onTap: () => cubit.selectTab(MainShellTab.stats),
              ),
              RunZoneBottomNavigationItem(
                label: MainShellTab.myPage.label,
                iconAsset: 'assets/icons/user.svg',
                isSelected: state.selectedTab == MainShellTab.myPage,
                onTap: () => cubit.selectTab(MainShellTab.myPage),
              ),
            ],
          ),
        );
      },
    );
  }
}
