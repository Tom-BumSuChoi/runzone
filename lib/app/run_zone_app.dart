import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:runzone/app/cubit/app_cubit.dart';
import 'package:runzone/app/di.dart';
import 'package:runzone/app/main_shell.dart';
import 'package:runzone/app/splash_screen.dart';
import 'package:runzone/core/design_system/app_theme.dart';
import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:runzone/features/workout/presentation/heart_rate_zone_setup_screen.dart';

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
            AppReady(hasProfile: false) => const HeartRateZoneSetupScreen(),
          },
        ),
      ),
    );
  }
}
