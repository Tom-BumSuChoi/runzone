import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:runzone/features/workout/presentation/cubit/workout_setup_cubit.dart';

void main() {
  test('Given 새로 생성한 cubit When 초기 상태를 확인하면 Then 실내 운동 환경과 존2 지속주를 가진다', () {
    final WorkoutSetupCubit cubit = WorkoutSetupCubit();

    expect(cubit.state, WorkoutSetupState.initial());
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
}
