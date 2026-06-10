import 'package:equatable/equatable.dart';

final class Height extends Equatable {
  Height(this.centimeters) {
    if (!isValid(centimeters)) {
      throw ArgumentError.value(centimeters, 'centimeters', 'must be between $min and $max');
    }
  }

  static const int min = 100;
  static const int max = 250;

  final int centimeters;

  static bool isValid(int centimeters) => centimeters >= min && centimeters <= max;

  @override
  List<Object?> get props => [centimeters];
}
