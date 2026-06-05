import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primitive
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);

  static const gray100 = Color(0xFFF3F5F7);
  static const gray400 = Color(0xFFA4ABB6);
  static const gray500 = Color(0xFF6B7280);
  static const gray600 = Color(0xFF353A43);
  static const gray700 = Color(0xFF262A31);
  static const gray800 = Color(0xFF1C2026);
  static const gray850 = Color(0xFF16191F);
  static const gray900 = Color(0xFF111317);
  static const gray950 = Color(0xFF0A0B0D);
  static const gray1000 = Color(0xFF050608);

  static const lime300 = Color(0xFFE8FF3A);
  static const lime400 = Color(0xFFC6E000);
  static const lime500 = Color(0xFFAAC400);

  static const blue500 = Color(0xFF3B82F6);
  static const green500 = Color(0xFF22C55E);
  static const yellow500 = Color(0xFFEAB308);
  static const orange500 = Color(0xFFF97316);
  static const red500 = Color(0xFFEF4444);

  // Dark semantic
  static const pageBackground = gray1000;
  static const background = gray950;
  static const surface = gray900;
  static const secondarySurface = gray850;
  static const elevatedSurface = gray800;
  static const line = gray700;
  static const secondaryLine = gray600;

  static const text = gray100;
  static const dimText = gray400;
  static const mutedText = gray500;

  static const accent = lime300;
  static const secondaryAccent = lime400;
  static const accentInk = gray950;
  static const accentGlow = Color(0x38E8FF3A);

  // Light semantic
  static const lightPageBackground = gray100;
  static const lightBackground = white;
  static const lightSurface = white;
  static const lightSecondarySurface = gray100;
  static const lightElevatedSurface = white;
  static const lightLine = gray400;
  static const lightSecondaryLine = gray500;

  static const lightText = gray950;
  static const lightDimText = gray500;
  static const lightMutedText = gray400;

  static const lightAccent = lime400;
  static const lightSecondaryAccent = lime500;
  static const lightAccentInk = gray950;
  static const lightAccentGlow = Color(0x47C6E000);

  // Zone
  static const zone1 = blue500;
  static const zone2 = green500;
  static const zone3 = yellow500;
  static const zone4 = orange500;
  static const zone5 = red500;

  static const zone1Dim = Color(0x293B82F6);
  static const zone2Dim = Color(0x2922C55E);
  static const zone3Dim = Color(0x29EAB308);
  static const zone4Dim = Color(0x29F97316);
  static const zone5Dim = Color(0x29EF4444);
}
