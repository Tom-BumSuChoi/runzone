import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runzone/features/workout/domain/heart_rate_zone.dart';
import 'package:runzone/features/workout/domain/workout_duration_goal.dart';
import 'package:runzone/features/workout/presentation/cubit/workout_setup_cubit.dart';

void main() {
  test('Given 새로 생성한 cubit When 초기 상태를 확인하면 Then 실내 운동 환경과 목표존 지속주와 연결된 심박 기기 상태를 가진다', () {
    final WorkoutSetupCubit cubit = WorkoutSetupCubit();

    expect(cubit.state, WorkoutSetupState.initial());
    expect(cubit.state.isHeartRateDeviceConnected, isTrue);
    expect(cubit.state.targetZoneDurationGoal, WorkoutDurationGoal.initial());
    expect(cubit.state.targetHeartRateZone, HeartRateZone.zone2);
  });

  test('Given 실내 운동 환경과 러닝머신 미연결 상태 When 시작 가능 여부를 확인하면 Then 시작할 수 없다', () {
    const state = WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      trainingType: WorkoutTrainingType.targetZone,
    );

    expect(state.canStart, isFalse);
  });

  test('Given 실내 운동 환경과 러닝머신 연결 상태 When 시작 가능 여부를 확인하면 Then 시작할 수 있다', () {
    const state = WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      trainingType: WorkoutTrainingType.targetZone,
      isTreadmillConnected: true,
    );

    expect(state.canStart, isTrue);
  });

  test('Given 실내 운동 환경과 러닝머신 연결 상태지만 심박 기기가 미연결이면 When 시작 가능 여부를 확인하면 Then 시작할 수 없다', () {
    const state = WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      trainingType: WorkoutTrainingType.targetZone,
      isHeartRateDeviceConnected: false,
      isTreadmillConnected: true,
    );

    expect(state.canStart, isFalse);
  });

  test('Given 야외 운동 환경 When 시작 가능 여부를 확인하면 Then 러닝머신 연결 없이 시작할 수 있다', () {
    const state = WorkoutSetupState(
      environment: WorkoutEnvironment.outdoor,
      trainingType: WorkoutTrainingType.targetZone,
    );

    expect(state.canStart, isTrue);
  });

  test('Given 야외 운동 환경이지만 심박 기기가 미연결이면 When 시작 가능 여부를 확인하면 Then 시작할 수 없다', () {
    const state = WorkoutSetupState(
      environment: WorkoutEnvironment.outdoor,
      trainingType: WorkoutTrainingType.targetZone,
      isHeartRateDeviceConnected: false,
    );

    expect(state.canStart, isFalse);
  });

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 운동 환경을 변경하면 Then 선택한 운동 환경을 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.changeEnvironment(WorkoutEnvironment.outdoor),
    expect: () => [
      const WorkoutSetupState(environment: WorkoutEnvironment.outdoor, trainingType: WorkoutTrainingType.targetZone),
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
        trainingType: WorkoutTrainingType.targetZone,
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
        trainingType: WorkoutTrainingType.targetZone,
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
        trainingType: WorkoutTrainingType.targetZone,
        isZoneAlertEnabled: false,
      ),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 목표존 목표 시간을 증가하면 Then 5분 증가한 목표 시간을 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.increaseTargetZoneDuration(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        trainingType: WorkoutTrainingType.targetZone,
        targetZoneDurationGoal: WorkoutDurationGoal(minutes: 45),
      ),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 목표존 목표 시간을 감소하면 Then 5분 감소한 목표 시간을 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.decreaseTargetZoneDuration(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        trainingType: WorkoutTrainingType.targetZone,
        targetZoneDurationGoal: WorkoutDurationGoal(minutes: 35),
      ),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given 목표존 목표 시간이 5분인 cubit When 목표존 목표 시간을 감소하면 Then 변경된 상태를 방출하지 않고 5분을 유지한다',
    build: WorkoutSetupCubit.new,
    seed: () => const WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      trainingType: WorkoutTrainingType.targetZone,
      targetZoneDurationGoal: WorkoutDurationGoal(minutes: 5),
    ),
    act: (cubit) => cubit.decreaseTargetZoneDuration(),
    expect: () => <WorkoutSetupState>[],
    verify: (cubit) => expect(cubit.state.targetZoneDurationGoal, const WorkoutDurationGoal(minutes: 5)),
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given 목표존 목표 시간이 995분인 cubit When 목표존 목표 시간을 증가하면 Then 변경된 상태를 방출하지 않고 995분을 유지한다',
    build: WorkoutSetupCubit.new,
    seed: () => const WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      trainingType: WorkoutTrainingType.targetZone,
      targetZoneDurationGoal: WorkoutDurationGoal(minutes: 995),
    ),
    act: (cubit) => cubit.increaseTargetZoneDuration(),
    expect: () => <WorkoutSetupState>[],
    verify: (cubit) => expect(cubit.state.targetZoneDurationGoal, const WorkoutDurationGoal(minutes: 995)),
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 목표 심박존을 증가하면 Then 다음 목표 심박존을 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.increaseTargetHeartRateZone(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        trainingType: WorkoutTrainingType.targetZone,
        targetHeartRateZone: HeartRateZone.zone3,
      ),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 목표 심박존을 감소하면 Then 이전 목표 심박존을 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.decreaseTargetHeartRateZone(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        trainingType: WorkoutTrainingType.targetZone,
        targetHeartRateZone: HeartRateZone.zone1,
      ),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given 목표 심박존이 Z1인 cubit When 목표 심박존을 감소하면 Then 변경된 상태를 방출하지 않고 Z1을 유지한다',
    build: WorkoutSetupCubit.new,
    seed: () => const WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      trainingType: WorkoutTrainingType.targetZone,
      targetHeartRateZone: HeartRateZone.zone1,
    ),
    act: (cubit) => cubit.decreaseTargetHeartRateZone(),
    expect: () => <WorkoutSetupState>[],
    verify: (cubit) => expect(cubit.state.targetHeartRateZone, HeartRateZone.zone1),
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given 목표 심박존이 Z5인 cubit When 목표 심박존을 증가하면 Then 변경된 상태를 방출하지 않고 Z5를 유지한다',
    build: WorkoutSetupCubit.new,
    seed: () => const WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      trainingType: WorkoutTrainingType.targetZone,
      targetHeartRateZone: HeartRateZone.zone5,
    ),
    act: (cubit) => cubit.increaseTargetHeartRateZone(),
    expect: () => <WorkoutSetupState>[],
    verify: (cubit) => expect(cubit.state.targetHeartRateZone, HeartRateZone.zone5),
  );
}
