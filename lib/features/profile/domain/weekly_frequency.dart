import 'package:equatable/equatable.dart';

final class WeeklyFrequency extends Equatable {
  WeeklyFrequency(this.count) {
    if (count < _min || count > _max) {
      throw ArgumentError.value(count, 'count', 'must be between $_min and $_max');
    }
  }

  static const int _min = 1;
  static const int _max = 14;

  final int count;

  @override
  List<Object?> get props => [count];
}
