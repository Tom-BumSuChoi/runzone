part of 'heart_rate_zone_summary_cubit.dart';

final class HeartRateZoneSummaryState extends Equatable {
  const HeartRateZoneSummaryState({this.zone});

  factory HeartRateZoneSummaryState.initial() => const HeartRateZoneSummaryState();

  final HeartRateZone? zone;

  @override
  List<Object?> get props => [zone];
}
