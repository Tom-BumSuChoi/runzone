import 'package:flutter/material.dart';

abstract final class AppTypography {
  // Font Family
  static const sans = 'IBM Plex Sans KR';
  static const mono = 'IBM Plex Mono';

  // Sans KR / Display & UI
  static const display = TextStyle(
    fontFamily: sans,
    fontSize: 56,
    fontWeight: FontWeight.w600,
    height: 1.05,
    letterSpacing: -1.4,
  );

  static const h1 = TextStyle(
    fontFamily: sans,
    fontSize: 27,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
  );

  static const h2 = TextStyle(
    fontFamily: sans,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const h3 = TextStyle(
    fontFamily: sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(
    fontFamily: sans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );

  static const small = TextStyle(
    fontFamily: sans,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const caption = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );

  // Mono / Numbers & Metadata
  static const eyebrow = TextStyle(
    fontFamily: mono,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.6,
  );

  static const monoBigNumber = TextStyle(
    fontFamily: mono,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );

  static const monoTag = TextStyle(
    fontFamily: mono,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.6,
  );

  static const monoUi = TextStyle(
    fontFamily: mono,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.48,
  );
}
