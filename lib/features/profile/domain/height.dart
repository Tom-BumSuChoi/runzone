import 'package:equatable/equatable.dart';

final class Height extends Equatable {
  Height(this.centimeters) {
    if (centimeters < _min || centimeters > _max) {
      throw ArgumentError.value(centimeters, 'centimeters', 'must be between $_min and $_max');
    }
  }

  static const int _min = 100;
  static const int _max = 250;

  final int centimeters;

  Height incremented() => centimeters >= _max ? this : Height(centimeters + 1);

  Height decremented() => centimeters <= _min ? this : Height(centimeters - 1);

  @override
  List<Object?> get props => [centimeters];
}
