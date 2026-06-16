import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runzone/features/workout/presentation/cubit/workout_setup_cubit.dart';

void main() {
  test('Given 새로 생성한 cubit When 초기 상태를 확인하면 Then 실내 운동 환경과 존2 지속주와 연결된 심박 기기 상태를 가진다', () {
    final WorkoutSetupCubit cubit = WorkoutSetupCubit();

    expect(cubit.state, WorkoutSetupState.initial());
    expect(cubit.state.isHeartRateDeviceConnected, isTrue);
  });

  test('Given 실내 운동 환경과 러닝머신 미연결 상태 When 시작 가능 여부를 확인하면 Then 시작할 수 없다', () {
    const state = WorkoutSetupState(environment: WorkoutEnvironment.indoor, trainingType: WorkoutTrainingType.zoneTwo);

    expect(state.canStart, isFalse);
  });

  test('Given 실내 운동 환경과 러닝머신 연결 상태 When 시작 가능 여부를 확인하면 Then 시작할 수 있다', () {
    const state = WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      trainingType: WorkoutTrainingType.zoneTwo,
      isTreadmillConnected: true,
    );

    expect(state.canStart, isTrue);
  });

  test('Given 실내 운동 환경과 러닝머신 연결 상태지만 심박 기기가 미연결이면 When 시작 가능 여부를 확인하면 Then 시작할 수 없다', () {
    const state = WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      trainingType: WorkoutTrainingType.zoneTwo,
      isHeartRateDeviceConnected: false,
      isTreadmillConnected: true,
    );

    expect(state.canStart, isFalse);
  });

  test('Given 야외 운동 환경 When 시작 가능 여부를 확인하면 Then 러닝머신 연결 없이 시작할 수 있다', () {
    const state = WorkoutSetupState(environment: WorkoutEnvironment.outdoor, trainingType: WorkoutTrainingType.zoneTwo);

    expect(state.canStart, isTrue);
  });

  test('Given 야외 운동 환경이지만 심박 기기가 미연결이면 When 시작 가능 여부를 확인하면 Then 시작할 수 없다', () {
    const state = WorkoutSetupState(
      environment: WorkoutEnvironment.outdoor,
      trainingType: WorkoutTrainingType.zoneTwo,
      isHeartRateDeviceConnected: false,
    );

    expect(state.canStart, isFalse);
  });

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 운동 환경을 변경하면 Then 선택한 운동 환경을 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.changeEnvironment(WorkoutEnvironment.outdoor),
    expect: () => [
      const WorkoutSetupState(environment: WorkoutEnvironment.outdoor, trainingType: WorkoutTrainingType.zoneTwo),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 훈련 종류를 변경하면 Then 선택한 훈련 종류를 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.changeTrainingType(WorkoutTrainingType.interval),
    expect: () => [
      const WorkoutSetupState(environment: WorkoutEnvironment.indoor, trainingType: WorkoutTrainingType.interval),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 러닝머신 연결 상태를 토글하면 Then 변경된 연결 상태를 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.toggleTreadmillConnection(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        trainingType: WorkoutTrainingType.zoneTwo,
        isTreadmillConnected: true,
      ),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 자동 페이스 조절 상태를 토글하면 Then 변경된 자동 페이스 조절 상태를 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.toggleAutoPace(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        trainingType: WorkoutTrainingType.zoneTwo,
        isAutoPaceEnabled: false,
      ),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 존 이탈 알림 상태를 토글하면 Then 변경된 존 이탈 알림 상태를 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.toggleZoneAlert(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        trainingType: WorkoutTrainingType.zoneTwo,
        isZoneAlertEnabled: false,
      ),
    ],
  );
}
