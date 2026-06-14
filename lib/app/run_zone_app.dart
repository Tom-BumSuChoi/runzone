import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/design_system/app_theme.dart';
import '../features/profile/domain/profile_repository.dart';
import '../features/profile/presentation/runner_profile_setup_screen.dart';
import 'cubit/app_cubit.dart';
import 'di.dart';
import 'main_shell.dart';
import 'splash_screen.dart';

final class RunZoneApp extends StatelessWidget {
  const RunZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit(repository: getIt<ProfileRepository>()),
      child: MaterialApp(
        title: 'Run Zone',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: AppTheme.themeMode,
        home: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) => switch (state) {
            AppInitial() => const SplashScreen(),
            AppReady(hasProfile: true) => const MainShell(),
            AppReady(hasProfile: false) => const RunnerProfileSetupScreen(),
          },
        ),
      ),
    );
  }
}
