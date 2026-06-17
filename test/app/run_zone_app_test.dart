import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:runzone/app/di.dart';
import 'package:runzone/app/main_shell.dart';
import 'package:runzone/app/run_zone_app.dart';
import 'package:runzone/features/profile/domain/profile_repository.dart';
import 'package:runzone/features/profile/domain/runner_profile.dart';
import '../helpers/test_device_size.dart';

final class _FakeProfileRepository implements ProfileRepository {
  RunnerProfile? saved;
  final StreamController<RunnerProfile?> _controller = StreamController<RunnerProfile?>.broadcast();

  @override
  Future<void> save(RunnerProfile profile) async {
    saved = profile;
    _controller.add(profile);
  }

  @override
  Future<RunnerProfile?> load() async => saved;

  @override
  Stream<RunnerProfile?> watchProfile() async* {
    yield saved;
    yield* _controller.stream;
  }

  Future<void> close() => _controller.close();
}

void main() {
  late _FakeProfileRepository repository;

  setUp(() {
    repository = _FakeProfileRepository();
    getIt.registerSingleton<ProfileRepository>(repository);
  });

  tearDown(() async {
    await repository.close();
    await getIt.reset();
  });

  testWidgets('Given 프로필이 없을 때 When 프로필 입력에서 시작하기를 누르면 Then 저장 후 홈으로 간다', (tester) async {
    tester.view.physicalSize = testDeviceSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const RunZoneApp());
    await tester.pumpAndSettle();

    expect(find.text('프로필 입력'), findsOneWidget);

    await tester.tap(find.text('시작하기'));
    await tester.pumpAndSettle();

    expect(repository.saved, isNotNull);
    expect(find.byType(MainShell), findsOneWidget);
  });
}
