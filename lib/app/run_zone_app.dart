import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/design_system/app_theme.dart';
import '../features/profile/domain/profile_repository.dart';
import 'app_router.dart';
import 'cubit/app_cubit.dart';
import 'di.dart';

final class RunZoneApp extends StatelessWidget {
  const RunZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit(repository: getIt<ProfileRepository>()),
      child: Builder(
        builder: (context) {
          return _RunZoneMaterialApp(appCubit: context.read<AppCubit>());
        },
      ),
    );
  }
}

final class _RunZoneMaterialApp extends StatefulWidget {
  const _RunZoneMaterialApp({required this.appCubit});

  final AppCubit appCubit;

  @override
  State<_RunZoneMaterialApp> createState() => _RunZoneMaterialAppState();
}

final class _RunZoneMaterialAppState extends State<_RunZoneMaterialApp> {
  late final _AppCubitRouterRefresh _routerRefresh = _AppCubitRouterRefresh(widget.appCubit);
  late final GoRouter _appRouter = createAppRouter(appCubit: widget.appCubit, refreshListenable: _routerRefresh);

  @override
  void dispose() {
    _appRouter.dispose();
    _routerRefresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Run Zone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: AppTheme.themeMode,
      routerConfig: _appRouter,
    );
  }
}

final class _AppCubitRouterRefresh extends ChangeNotifier {
  _AppCubitRouterRefresh(AppCubit appCubit) {
    _subscription = appCubit.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AppState> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
