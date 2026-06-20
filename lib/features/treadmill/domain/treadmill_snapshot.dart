import 'package:equatable/equatable.dart';

final class TreadmillSnapshot extends Equatable {
  const TreadmillSnapshot({required this.speedKilometersPerHour, required this.isManualMode});

  final double speedKilometersPerHour;
  final bool isManualMode;

  @override
  List<Object?> get props => [speedKilometersPerHour, isManualMode];
}
