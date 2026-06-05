import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primitive / Base
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);

  // Primitive / Gray
  static const gray0 = Color(0xFFF3F5F7);
  static const gray500 = Color(0xFFA4ABB6);
  static const gray700 = Color(0xFF353A43);
  static const gray800 = Color(0xFF262A31);
  static const gray850 = Color(0xFF1C2026);
  static const gray900 = Color(0xFF16191F);
  static const gray925 = Color(0xFF111317);
  static const gray950 = Color(0xFF0A0B0D);
  static const gray990 = Color(0xFF050608);

  // Primitive / Brand
  static const lime400 = Color(0xFFE8FF3A);
  static const lime500 = Color(0xFFC6E000);

  // Primitive / Signal
  static const blue400 = Color(0xFF3B82F6);
  static const green400 = Color(0xFF22C55E);
  static const yellow400 = Color(0xFFEAB308);
  static const orange400 = Color(0xFFF97316);
  static const red400 = Color(0xFFEF4444);

  // Background / Surface
  static const backgroundPage = gray990;
  static const backgroundApp = gray950;
  static const surfaceCard = gray925;
  static const surfaceRaised = gray900;
  static const surfaceElevated = gray850;

  // Border
  static const borderSubtle = gray800;
  static const borderStrong = gray700;

  // Text
  static const textPrimary = gray0;
  static const textSecondary = gray500;

  // Action
  static const actionPrimary = lime400;
  static const actionPrimaryPressed = lime500;
  static const actionOnPrimary = gray950;
  static const actionPrimarySoft = Color(0x24E8FF3A);
  static const actionPrimaryGlow = Color(0x29E8FF3A);

  // Heart Zone
  static const zoneRecovery = blue400;
  static const zoneEndurance = green400;
  static const zoneTempo = yellow400;
  static const zoneThreshold = orange400;
  static const zonePeak = red400;

  // Feedback
  static const feedbackSuccess = green400;
  static const feedbackWarning = yellow400;
  static const feedbackDanger = red400;

  // Overlay / Shadow
  static const overlaySubtle = Color(0x12F3F5F7);
  static const shadowDevice = Color(0xA8000000);
  static const shadowModal = Color(0x94000000);
}
