import 'package:runzone/features/workout/domain/runner_profile.dart';

abstract interface class ProfileRepository {
  Future<void> save(RunnerProfile profile);
}
