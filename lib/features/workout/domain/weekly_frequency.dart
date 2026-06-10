import 'package:equatable/equatable.dart';

final class WeeklyFrequency extends Equatable {
  WeeklyFrequency(this.count) {
    if (!isValid(count)) {
      throw ArgumentError.value(count, 'count', 'must be between $min and $max');
    }
  }

  static const int min = 1;
  static const int max = 14;

  final int count;

  static bool isValid(int count) => count >= min && count <= max;

  @override
  List<Object?> get props => [count];
}
