import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../features/profile/presentation/runner_profile_setup_screen.dart';
import '../features/workout/presentation/workout_countdown_screen.dart';
import '../features/workout/presentation/workout_live_screen.dart';
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
      GoRoute(
        path: AppRoutes.workoutCountdown,
        pageBuilder: (_, _) => const NoTransitionPage(child: WorkoutCountdownScreen()),
      ),
      GoRoute(
        path: AppRoutes.workoutLive,
        pageBuilder: (_, _) => const NoTransitionPage(child: WorkoutLiveScreen()),
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
