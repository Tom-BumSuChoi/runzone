import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/heart_rate/data/mock_heart_rate_monitor.dart';
import '../features/heart_rate/domain/heart_rate_zone.dart';
import '../features/heart_rate/domain/heart_rate_zone_range.dart';
import '../features/profile/presentation/runner_profile_setup_screen.dart';
import '../features/treadmill/data/mock_treadmill_device.dart';
import '../features/workout/presentation/bloc/workout_session_bloc.dart';
import '../features/workout/presentation/workout_countdown_screen.dart';
import '../features/workout/presentation/workout_live_screen.dart';
import '../features/workout/presentation/workout_ready_screen.dart';
import 'app_routes.dart';
import 'cubit/app_cubit.dart';
import 'main_shell.dart';
import 'splash_screen.dart';

GoRouter createAppRouter({required AppCubit appCubit, required Listenable refreshListenable}) {
  return GoRouter(
    refreshListenable: refreshListenable,
    redirect: (_, state) => _redirect(state: state, appState: appCubit.state),
    routes: [
      GoRoute(path: AppRoutes.root, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.profileSetup, builder: (_, _) => const RunnerProfileSetupScreen()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const MainShell()),
      ShellRoute(
        pageBuilder: (_, _, child) => CustomTransitionPage(
          child: BlocProvider(
            create: (_) => WorkoutSessionBloc(
              heartRateMonitor: MockHeartRateMonitor(),
              treadmillDevice: MockTreadmillDevice(),
              heartRateZoneTable: const HeartRateZoneTable(
                zone1: HeartRateZoneRange(lower: 96, upper: 120),
                zone2: HeartRateZoneRange(lower: 121, upper: 148),
                zone3: HeartRateZoneRange(lower: 149, upper: 160),
                zone4: HeartRateZoneRange(lower: 161, upper: 172),
                zone5: HeartRateZoneRange(lower: 173, upper: 182),
              ),
              targetHeartRateZone: HeartRateZone.zone2,
            ),
            child: child,
          ),
          transitionsBuilder: (_, animation, _, child) {
            final position = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

            return SlideTransition(position: position, child: child);
          },
        ),
        routes: [
          GoRoute(
            path: AppRoutes.workoutReady,
            pageBuilder: (_, _) => const NoTransitionPage(child: WorkoutReadyScreen()),
          ),
          GoRoute(
            path: AppRoutes.workoutCountdown,
            pageBuilder: (_, _) => const NoTransitionPage(child: WorkoutCountdownScreen()),
          ),
          GoRoute(
            path: AppRoutes.workoutLive,
            pageBuilder: (_, _) => const NoTransitionPage(child: WorkoutLiveScreen()),
          ),
        ],
      ),
    ],
  );
}

String? _redirect({required GoRouterState state, required AppState appState}) {
  final path = state.uri.path;

  return switch (appState) {
    AppInitial() => path == AppRoutes.splash ? null : AppRoutes.splash,
    AppReady(hasProfile: false) => path == AppRoutes.profileSetup ? null : AppRoutes.profileSetup,
    AppReady(hasProfile: true) => switch (path) {
      AppRoutes.root || AppRoutes.splash || AppRoutes.profileSetup => AppRoutes.home,
      _ => null,
    },
  };
}
