import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../heart_rate/domain/heart_rate_zone.dart';
import '../../domain/workout_plan.dart';
import '../../domain/workout_session.dart';

final class WorkoutResultCubit extends Cubit<WorkoutResultState> {
  WorkoutResultCubit({required this.session}) : super(WorkoutResultState.fromSession(session));

  final WorkoutSession session;
}

final class WorkoutResultState extends Equatable {
  const WorkoutResultState({
    required this.subtitle,
    required this.distanceKm,
    required this.durationLabel,
    required this.averageBpm,
    required this.zoneProportions,
    required this.dominantZone,
    required this.dominantZonePercent,
  });

  factory WorkoutResultState.fromSession(WorkoutSession session) {
    final measurements = session.heartRateMeasurements;
    final total = measurements.length;

    int? averageBpm;
    if (total > 0) {
      final sum = measurements.fold<int>(0, (accumulator, measurement) {
        return accumulator + measurement.beatsPerMinute;
      });
      averageBpm = (sum / total).round();
    }

    final counts = <HeartRateZone, int>{for (final zone in HeartRateZone.values) zone: 0};
    for (final measurement in measurements) {
      final zone = session.heartRateZoneTable.getZoneType(measurement.beatsPerMinute);
      counts[zone] = (counts[zone] ?? 0) + 1;
    }

    final zoneProportions = <HeartRateZone, double>{
      for (final zone in HeartRateZone.values) zone: total == 0 ? 0 : (counts[zone] ?? 0) / total,
    };

    HeartRateZone? dominantZone;
    var dominantCount = 0;
    for (final zone in HeartRateZone.values) {
      final count = counts[zone] ?? 0;
      if (count > dominantCount) {
        dominantCount = count;
        dominantZone = zone;
      }
    }

    return WorkoutResultState(
      subtitle: '${_planLabel(session.plan)} · ${_formatDate(session.startedAt)}',
      distanceKm: session.totalDistanceMeters / 1000,
      durationLabel: _formatDuration(session.elapsed),
      averageBpm: averageBpm,
      zoneProportions: zoneProportions,
      dominantZone: dominantZone,
      dominantZonePercent: total == 0 ? 0 : ((dominantCount / total) * 100).round(),
    );
  }

  final String subtitle;
  final double distanceKm;
  final String durationLabel;
  final int? averageBpm;
  final Map<HeartRateZone, double> zoneProportions;
  final HeartRateZone? dominantZone;
  final int dominantZonePercent;

  @override
  List<Object?> get props => [
    subtitle,
    distanceKm,
    durationLabel,
    averageBpm,
    zoneProportions,
    dominantZone,
    dominantZonePercent,
  ];
}

String _two(int value) => value.toString().padLeft(2, '0');

String _formatDate(DateTime date) => '${date.year}.${_two(date.month)}.${_two(date.day)}';

String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '$hours:${_two(minutes)}:${_two(seconds)}';
  }

  return '${_two(minutes)}:${_two(seconds)}';
}

String _planLabel(WorkoutPlan plan) => switch (plan) {
  TargetZoneWorkoutPlan(:final targetHeartRateZone) => '존${targetHeartRateZone.index + 1} 지속주',
  IntervalWorkoutPlan() => '인터벌',
  FreeWorkoutPlan() => '자유 러닝',
};
