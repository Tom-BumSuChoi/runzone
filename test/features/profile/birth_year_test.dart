import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/features/profile/domain/birth_year.dart';

void main() {
  test('Given 경계를 포함한 유효한 출생연도 When 생성하면 Then 해당 값을 가진다', () {
    // 유효 범위 경계: 1940~2012
    for (final int year in [1940, 2012]) {
      expect(BirthYear(year).year, year, reason: '$year');
    }
  });

  test('Given 경계를 벗어난 출생연도 When 생성하면 Then 입력값 오류가 발생한다', () {
    for (final int year in [1939, 2013]) {
      BirthYear create() => BirthYear(year);

      expect(create, throwsArgumentError, reason: '$year');
    }
  });

  test('Given 출생연도 When incremented 하면 Then 1 증가한 값을 반환한다', () {
    expect(BirthYear(1996).incremented(), BirthYear(1997));
  });

  test('Given 최대 출생연도 When incremented 하면 Then 그대로 유지된다', () {
    expect(BirthYear(2012).incremented(), BirthYear(2012));
  });

  test('Given 출생연도 When decremented 하면 Then 1 감소한 값을 반환한다', () {
    expect(BirthYear(1996).decremented(), BirthYear(1995));
  });

  test('Given 최소 출생연도 When decremented 하면 Then 그대로 유지된다', () {
    expect(BirthYear(1940).decremented(), BirthYear(1940));
  });
}
