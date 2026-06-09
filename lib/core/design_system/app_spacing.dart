import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const tight = 6.0;
  static const close = 10.0;
  static const base = 14.0;
  static const loose = 18.0;
  static const wide = 22.0;

  static const cardPadding = 16.0;
  static const screenPadding = 20.0;
  static const buttonPaddingVertical = 13.0;
  static const buttonPaddingHorizontal = 18.0;
  static const chipPaddingVertical = 8.0;
  static const chipPaddingHorizontal = 14.0;

  static const touchTarget = 44.0;
  static const navHeight = 78.0;

  static const iconSmall = 17.0;
  static const iconMedium = 23.0;
  static const iconLarge = 26.0;

  static const tightGap = SizedBox(height: tight);
  static const closeGap = SizedBox(height: close);
  static const baseGap = SizedBox(height: base);
  static const looseGap = SizedBox(height: loose);
  static const wideGap = SizedBox(height: wide);

  static const tightHorizontalGap = SizedBox(width: tight);
  static const closeHorizontalGap = SizedBox(width: close);
  static const baseHorizontalGap = SizedBox(width: base);
  static const looseHorizontalGap = SizedBox(width: loose);
  static const wideHorizontalGap = SizedBox(width: wide);

  static const tightInsets = EdgeInsets.all(tight);
  static const closeInsets = EdgeInsets.all(close);
  static const baseInsets = EdgeInsets.all(base);
  static const looseInsets = EdgeInsets.all(loose);
  static const wideInsets = EdgeInsets.all(wide);

  static const cardInsets = EdgeInsets.all(cardPadding);
  static const screenInsets = EdgeInsets.all(screenPadding);
  static const buttonInsets = EdgeInsets.symmetric(
    vertical: buttonPaddingVertical,
    horizontal: buttonPaddingHorizontal,
  );
  static const chipInsets = EdgeInsets.symmetric(
    vertical: chipPaddingVertical,
    horizontal: chipPaddingHorizontal,
  );
}
