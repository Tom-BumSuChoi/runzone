import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runzone/features/workout/presentation/cubit/workout_setup_cubit.dart';

void main() {
  test('Given 새로 생성한 cubit When 초기 상태를 확인하면 Then 실내 운동 환경과 존2 지속주와 연결된 심박 기기 상태를 가진다', () {
    final WorkoutSetupCubit cubit = WorkoutSetupCubit();

    expect(cubit.state, WorkoutSetupState.initial());
    expect(cubit.state.isHeartRateDeviceConnected, isTrue);
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
}
