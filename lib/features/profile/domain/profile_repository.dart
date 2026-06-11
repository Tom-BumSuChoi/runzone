import 'package:runzone/features/profile/domain/runner_profile.dart';

abstract interface class ProfileRepository {
  Future<void> save(RunnerProfile profile);
  Future<RunnerProfile?> load();
}
