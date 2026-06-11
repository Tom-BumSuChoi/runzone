import 'package:equatable/equatable.dart';

final class Weight extends Equatable {
  Weight(this.kilograms) {
    if (kilograms < _min || kilograms > _max) {
      throw ArgumentError.value(kilograms, 'kilograms', 'must be between $_min and $_max');
    }
  }

  static const int _min = 30;
  static const int _max = 200;

  final int kilograms;

  Weight incremented() => kilograms >= _max ? this : Weight(kilograms + 1);

  Weight decremented() => kilograms <= _min ? this : Weight(kilograms - 1);

  @override
  List<Object?> get props => [kilograms];
}
