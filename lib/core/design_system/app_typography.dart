import 'package:flutter/material.dart';

abstract final class AppTypography {
  // Font families
  static const sansKorean = 'IBM Plex Sans KR';
  static const mono = 'IBM Plex Mono';

  // IBM Plex Sans KR
  static const display = TextStyle(
    fontFamily: sansKorean,
    fontSize: 56,
    fontWeight: FontWeight.w600,
    height: 1.05,
    letterSpacing: -1.4,
  );

  static const heading1 = TextStyle(
    fontFamily: sansKorean,
    fontSize: 27,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.4,
  );

  static const heading2 = TextStyle(
    fontFamily: sansKorean,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const heading3 = TextStyle(
    fontFamily: sansKorean,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const body = TextStyle(
    fontFamily: sansKorean,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );

  static const small = TextStyle(
    fontFamily: sansKorean,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const caption = TextStyle(
    fontFamily: sansKorean,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // IBM Plex Mono
  static const eyebrow = TextStyle(
    fontFamily: mono,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1,
    letterSpacing: 1.6,
  );

  static const largeNumber = TextStyle(
    fontFamily: mono,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: -0.8,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );

  static const metadataTag = TextStyle(
    fontFamily: mono,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1,
    letterSpacing: 0.6,
  );
}
