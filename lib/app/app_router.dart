import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/heart_rate/data/mock_heart_rate_monitor.dart';
import '../features/heart_rate/domain/heart_rate_zone.dart';
import '../features/heart_rate/domain/heart_rate_zone_range.dart';
import '../features/profile/presentation/runner_profile_setup_screen.dart';
import '../features/treadmill/data/mock_treadmill_device.dart';
import '../features/workout/domain/workout_session.dart';
import '../features/workout/presentation/live/bloc/workout_live_bloc.dart';
import '../features/workout/presentation/live/workout_live_screen.dart';
import '../features/workout/presentation/ready/workout_ready_cubit.dart';
import '../features/workout/presentation/ready/workout_ready_screen.dart';
import 'app_routes.dart';
import 'cubit/app_cubit.dart';
import 'main_shell.dart';
import 'splash_screen.dart';

const _heartRateZoneTable = HeartRateZoneTable(
  zone1: HeartRateZoneRange(lower: 96, upper: 120),
  zone2: HeartRateZoneRange(lower: 121, upper: 148),
  zone3: HeartRateZoneRange(lower: 149, upper: 160),
  zone4: HeartRateZoneRange(lower: 161, upper: 172),
  zone5: HeartRateZoneRange(lower: 173, upper: 182),
);

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
          child: child,
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
            pageBuilder: (context, _) => NoTransitionPage(
              child: BlocProvider(
                create: (_) => WorkoutReadyCubit(
                  heartRateZoneTable: _heartRateZoneTable,
                  delegate: _WorkoutReadyDelegate(context),
                ),
                child: const WorkoutReadyScreen(),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.workoutLive,
            redirect: (_, state) => state.extra is _WorkoutLiveRouteInput ? null : AppRoutes.home,
            pageBuilder: (_, state) {
              final input = state.extra as _WorkoutLiveRouteInput;
              return NoTransitionPage(
                child: BlocProvider(
                  create: (_) => WorkoutLiveBloc(
                    session: input.session,
                    isAutoPaceEnabled: input.isAutoPaceEnabled,
                    heartRateMonitor: MockHeartRateMonitor(),
                    treadmillDevice: MockTreadmillDevice(),
                    delegate: const _WorkoutLiveDelegate(),
                  ),
                  child: const WorkoutLiveScreen(),
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}

typedef _WorkoutLiveRouteInput = ({WorkoutSession session, bool isAutoPaceEnabled});

final class _WorkoutLiveDelegate implements WorkoutLiveDelegate {
  const _WorkoutLiveDelegate();

  @override
  void pauseWorkout({required WorkoutSession session}) {}

  @override
  void endWorkout({required WorkoutSession session}) {}
}

final class _WorkoutReadyDelegate implements WorkoutReadyDelegate {
  const _WorkoutReadyDelegate(this.context);

  final BuildContext context;

  @override
  void closeWorkoutReady() {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }

    router.go(AppRoutes.home);
  }

  @override
  void startWorkout({required WorkoutSession session, required bool isAutoPaceEnabled}) {
    GoRouter.of(context).go(
      AppRoutes.workoutLive,
      extra: (session: session, isAutoPaceEnabled: isAutoPaceEnabled),
    );
  }
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
