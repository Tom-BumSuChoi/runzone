import 'package:get_it/get_it.dart';
import 'package:runzone/features/profile/data/shared_preferences_profile_repository.dart';
import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();

  if (!getIt.isRegistered<SharedPreferences>()) {
    getIt.registerSingleton<SharedPreferences>(preferences);
  }

  if (!getIt.isRegistered<ProfileRepository>()) {
    getIt.registerLazySingleton<ProfileRepository>(
      () => SharedPreferencesProfileRepository(getIt<SharedPreferences>()),
    );
  }
}
