import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runzone/features/heart_rate/domain/heart_rate_zone.dart';
import 'package:runzone/features/workout/domain/workout_duration_goal.dart';
import 'package:runzone/features/workout/domain/workout_plan.dart';
import 'package:runzone/features/workout/presentation/cubit/workout_setup_cubit.dart';

void main() {
  test('Given 새로 생성한 cubit When 초기 상태를 확인하면 Then 실내 운동 환경과 목표존 지속주와 연결된 심박 기기 상태를 가진다', () {
    final WorkoutSetupCubit cubit = WorkoutSetupCubit();

    expect(cubit.state, WorkoutSetupState.initial());
    expect(cubit.state.isHeartRateDeviceConnected, isTrue);
    expect(cubit.state.plan, TargetZoneWorkoutPlan.initial);
  });

  test('Given 실내 운동 환경과 러닝머신 미연결 상태 When 시작 가능 여부를 확인하면 Then 시작할 수 없다', () {
    const state = WorkoutSetupState(environment: WorkoutEnvironment.indoor);

    expect(state.canStart, isFalse);
  });

  test('Given 실내 운동 환경과 러닝머신 연결 상태 When 시작 가능 여부를 확인하면 Then 시작할 수 있다', () {
    const state = WorkoutSetupState(environment: WorkoutEnvironment.indoor, isTreadmillConnected: true);

    expect(state.canStart, isTrue);
  });

  test('Given 실내 운동 환경과 러닝머신 연결 상태지만 심박 기기가 미연결이면 When 시작 가능 여부를 확인하면 Then 시작할 수 없다', () {
    const state = WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      isHeartRateDeviceConnected: false,
      isTreadmillConnected: true,
    );

    expect(state.canStart, isFalse);
  });

  test('Given 야외 운동 환경 When 시작 가능 여부를 확인하면 Then 러닝머신 연결 없이 시작할 수 있다', () {
    const state = WorkoutSetupState(environment: WorkoutEnvironment.outdoor);

    expect(state.canStart, isTrue);
  });

  test('Given 야외 운동 환경이지만 심박 기기가 미연결이면 When 시작 가능 여부를 확인하면 Then 시작할 수 없다', () {
    const state = WorkoutSetupState(environment: WorkoutEnvironment.outdoor, isHeartRateDeviceConnected: false);

    expect(state.canStart, isFalse);
  });

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 운동 환경을 변경하면 Then 선택한 운동 환경을 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.changeEnvironment(WorkoutEnvironment.outdoor),
    expect: () => [const WorkoutSetupState(environment: WorkoutEnvironment.outdoor)],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 인터벌 계획을 선택하면 Then 인터벌 계획을 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.selectIntervalPlan(),
    expect: () => [const WorkoutSetupState(environment: WorkoutEnvironment.indoor, plan: IntervalWorkoutPlan.initial)],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 러닝머신 연결 상태를 토글하면 Then 변경된 연결 상태를 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.toggleTreadmillConnection(),
    expect: () => [const WorkoutSetupState(environment: WorkoutEnvironment.indoor, isTreadmillConnected: true)],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 자동 페이스 조절 상태를 토글하면 Then 변경된 자동 페이스 조절 상태를 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.toggleAutoPace(),
    expect: () => [const WorkoutSetupState(environment: WorkoutEnvironment.indoor, isAutoPaceEnabled: false)],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 존 이탈 알림 상태를 토글하면 Then 변경된 존 이탈 알림 상태를 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.toggleZoneAlert(),
    expect: () => [const WorkoutSetupState(environment: WorkoutEnvironment.indoor, isZoneAlertEnabled: false)],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 목표존 목표 시간을 증가하면 Then 5분 증가한 목표 시간을 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.increaseTargetZoneDuration(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        plan: TargetZoneWorkoutPlan(
          durationGoal: WorkoutDurationGoal(minutes: 45),
          targetHeartRateZone: HeartRateZone.zone2,
        ),
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
        plan: TargetZoneWorkoutPlan(
          durationGoal: WorkoutDurationGoal(minutes: 35),
          targetHeartRateZone: HeartRateZone.zone2,
        ),
      ),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given 목표존 목표 시간이 5분인 cubit When 목표존 목표 시간을 감소하면 Then 변경된 상태를 방출하지 않고 5분을 유지한다',
    build: WorkoutSetupCubit.new,
    seed: () => const WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      plan: TargetZoneWorkoutPlan(
        durationGoal: WorkoutDurationGoal(minutes: 5),
        targetHeartRateZone: HeartRateZone.zone2,
      ),
    ),
    act: (cubit) => cubit.decreaseTargetZoneDuration(),
    expect: () => <WorkoutSetupState>[],
    verify: (cubit) {
      final plan = cubit.state.plan;
      expect(plan, isA<TargetZoneWorkoutPlan>());
      expect((plan as TargetZoneWorkoutPlan).durationGoal, const WorkoutDurationGoal(minutes: 5));
    },
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given 목표존 목표 시간이 995분인 cubit When 목표존 목표 시간을 증가하면 Then 변경된 상태를 방출하지 않고 995분을 유지한다',
    build: WorkoutSetupCubit.new,
    seed: () => const WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      plan: TargetZoneWorkoutPlan(
        durationGoal: WorkoutDurationGoal(minutes: 995),
        targetHeartRateZone: HeartRateZone.zone2,
      ),
    ),
    act: (cubit) => cubit.increaseTargetZoneDuration(),
    expect: () => <WorkoutSetupState>[],
    verify: (cubit) {
      final plan = cubit.state.plan;
      expect(plan, isA<TargetZoneWorkoutPlan>());
      expect((plan as TargetZoneWorkoutPlan).durationGoal, const WorkoutDurationGoal(minutes: 995));
    },
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given cubit When 목표 심박존을 증가하면 Then 다음 목표 심박존을 방출한다',
    build: WorkoutSetupCubit.new,
    act: (cubit) => cubit.increaseTargetHeartRateZone(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        plan: TargetZoneWorkoutPlan(
          durationGoal: WorkoutDurationGoal(minutes: WorkoutDurationGoal.initialMinutes),
          targetHeartRateZone: HeartRateZone.zone3,
        ),
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
        plan: TargetZoneWorkoutPlan(
          durationGoal: WorkoutDurationGoal(minutes: WorkoutDurationGoal.initialMinutes),
          targetHeartRateZone: HeartRateZone.zone1,
        ),
      ),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given 목표 심박존이 Z1인 cubit When 목표 심박존을 감소하면 Then 변경된 상태를 방출하지 않고 Z1을 유지한다',
    build: WorkoutSetupCubit.new,
    seed: () => const WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      plan: TargetZoneWorkoutPlan(
        durationGoal: WorkoutDurationGoal(minutes: WorkoutDurationGoal.initialMinutes),
        targetHeartRateZone: HeartRateZone.zone1,
      ),
    ),
    act: (cubit) => cubit.decreaseTargetHeartRateZone(),
    expect: () => <WorkoutSetupState>[],
    verify: (cubit) {
      final plan = cubit.state.plan;
      expect(plan, isA<TargetZoneWorkoutPlan>());
      expect((plan as TargetZoneWorkoutPlan).targetHeartRateZone, HeartRateZone.zone1);
    },
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given 목표 심박존이 Z5인 cubit When 목표 심박존을 증가하면 Then 변경된 상태를 방출하지 않고 Z5를 유지한다',
    build: WorkoutSetupCubit.new,
    seed: () => const WorkoutSetupState(
      environment: WorkoutEnvironment.indoor,
      plan: TargetZoneWorkoutPlan(
        durationGoal: WorkoutDurationGoal(minutes: WorkoutDurationGoal.initialMinutes),
        targetHeartRateZone: HeartRateZone.zone5,
      ),
    ),
    act: (cubit) => cubit.increaseTargetHeartRateZone(),
    expect: () => <WorkoutSetupState>[],
    verify: (cubit) {
      final plan = cubit.state.plan;
      expect(plan, isA<TargetZoneWorkoutPlan>());
      expect((plan as TargetZoneWorkoutPlan).targetHeartRateZone, HeartRateZone.zone5);
    },
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given 인터벌 계획 When 워밍업 시간을 증가하면 Then 1분 증가한 인터벌 계획을 방출한다',
    build: WorkoutSetupCubit.new,
    seed: () => const WorkoutSetupState(environment: WorkoutEnvironment.indoor, plan: IntervalWorkoutPlan.initial),
    act: (cubit) => cubit.increaseIntervalWarmUpDuration(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        plan: IntervalWorkoutPlan(
          warmUpDuration: Duration(minutes: 6),
          highIntensityDistanceMeters: 400,
          recoveryDuration: Duration(seconds: 90),
          repeatCount: 6,
        ),
      ),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given 인터벌 계획 When 고강도 거리를 증가하면 Then 100m 증가한 인터벌 계획을 방출한다',
    build: WorkoutSetupCubit.new,
    seed: () => const WorkoutSetupState(environment: WorkoutEnvironment.indoor, plan: IntervalWorkoutPlan.initial),
    act: (cubit) => cubit.increaseIntervalHighIntensityDistance(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        plan: IntervalWorkoutPlan(
          warmUpDuration: Duration(minutes: 5),
          highIntensityDistanceMeters: 500,
          recoveryDuration: Duration(seconds: 90),
          repeatCount: 6,
        ),
      ),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given 인터벌 계획 When 회복 시간을 증가하면 Then 15초 증가한 인터벌 계획을 방출한다',
    build: WorkoutSetupCubit.new,
    seed: () => const WorkoutSetupState(environment: WorkoutEnvironment.indoor, plan: IntervalWorkoutPlan.initial),
    act: (cubit) => cubit.increaseIntervalRecoveryDuration(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        plan: IntervalWorkoutPlan(
          warmUpDuration: Duration(minutes: 5),
          highIntensityDistanceMeters: 400,
          recoveryDuration: Duration(seconds: 105),
          repeatCount: 6,
        ),
      ),
    ],
  );

  blocTest<WorkoutSetupCubit, WorkoutSetupState>(
    'Given 인터벌 계획 When 반복 횟수를 증가하면 Then 1회 증가한 인터벌 계획을 방출한다',
    build: WorkoutSetupCubit.new,
    seed: () => const WorkoutSetupState(environment: WorkoutEnvironment.indoor, plan: IntervalWorkoutPlan.initial),
    act: (cubit) => cubit.increaseIntervalRepeatCount(),
    expect: () => [
      const WorkoutSetupState(
        environment: WorkoutEnvironment.indoor,
        plan: IntervalWorkoutPlan(
          warmUpDuration: Duration(minutes: 5),
          highIntensityDistanceMeters: 400,
          recoveryDuration: Duration(seconds: 90),
          repeatCount: 7,
        ),
      ),
    ],
  );
}
