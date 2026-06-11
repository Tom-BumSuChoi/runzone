import 'package:equatable/equatable.dart';

final class BirthYear extends Equatable {
  BirthYear(this.year) {
    if (year < _min || year > _max) {
      throw ArgumentError.value(year, 'year', 'must be between $_min and $_max');
    }
  }

  static const int _min = 1940;
  static const int _max = 2012;

  final int year;

  BirthYear incremented() => year >= _max ? this : BirthYear(year + 1);

  BirthYear decremented() => year <= _min ? this : BirthYear(year - 1);

  @override
  List<Object?> get props => [year];
}
