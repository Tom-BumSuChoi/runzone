import 'package:equatable/equatable.dart';

final class Weight extends Equatable {
  Weight(this.kilograms) {
    if (!isValid(kilograms)) {
      throw ArgumentError.value(kilograms, 'kilograms', 'must be between $min and $max');
    }
  }

  static const int min = 30;
  static const int max = 200;

  final int kilograms;

  static bool isValid(int kilograms) => kilograms >= min && kilograms <= max;

  @override
  List<Object?> get props => [kilograms];
}
