import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/design_system/assets/run_zone_icon_asset.dart';
import '../core/design_system/widgets/label/run_zone_body_medium_label.dart';
import '../core/design_system/widgets/navigation/run_zone_bottom_navigation.dart';
import '../features/profile/presentation/heart_rate_zone_adjustment_screen.dart';
import 'app_routes.dart';
import 'cubit/main_shell_cubit.dart';

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
          body: switch (state.selectedTab) {
            MainShellTab.myPage => const HeartRateZoneAdjustmentScreen(),
            _ => Center(child: RunZoneBodyMediumLabel(state.selectedTab.label)),
          },
          bottomNavigationBar: RunZoneBottomNavigation(
            items: [
              RunZoneBottomNavigationItem(
                label: MainShellTab.home.label,
                icon: RunZoneIconAsset.home,
                isSelected: state.selectedTab == MainShellTab.home,
                onTap: () => cubit.selectTab(MainShellTab.home),
              ),
              RunZoneBottomNavigationItem(
                label: MainShellTab.plan.label,
                icon: RunZoneIconAsset.calendar,
                isSelected: state.selectedTab == MainShellTab.plan,
                onTap: () => cubit.selectTab(MainShellTab.plan),
              ),
              RunZoneBottomNavigationStartButton(onTap: () => GoRouter.of(context).push(AppRoutes.workoutReady)),
              RunZoneBottomNavigationItem(
                label: MainShellTab.stats.label,
                icon: RunZoneIconAsset.activity,
                isSelected: state.selectedTab == MainShellTab.stats,
                onTap: () => cubit.selectTab(MainShellTab.stats),
              ),
              RunZoneBottomNavigationItem(
                label: MainShellTab.myPage.label,
                icon: RunZoneIconAsset.user,
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
