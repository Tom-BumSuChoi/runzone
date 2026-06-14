import 'package:flutter/widgets.dart';

abstract final class AppRadius {
  static const smallValue = 10.0;
  static const mediumValue = 16.0;
  static const largeValue = 22.0;
  static const xlargeValue = 30.0;
  static const badgeValue = 8.0;
  static const colorSwatchValue = 2.0;
  static const chipValue = 11.0;
  static const toggleValue = 14.0;
  static const zoneSegmentValue = 7.0;
  static const progressValue = 3.0;
  static const pillValue = 999.0;
  static const screenValue = 42.0;
  static const deviceValue = 52.0;

  static const small = Radius.circular(smallValue);
  static const medium = Radius.circular(mediumValue);
  static const large = Radius.circular(largeValue);
  static const xlarge = Radius.circular(xlargeValue);
  static const badge = Radius.circular(badgeValue);
  static const colorSwatch = Radius.circular(colorSwatchValue);
  static const chip = Radius.circular(chipValue);
  static const toggle = Radius.circular(toggleValue);
  static const zoneSegment = Radius.circular(zoneSegmentValue);
  static const progress = Radius.circular(progressValue);
  static const pill = Radius.circular(pillValue);
  static const screen = Radius.circular(screenValue);
  static const device = Radius.circular(deviceValue);
  static const circle = BoxShape.circle;

  static const smallBorder = BorderRadius.all(small);
  static const mediumBorder = BorderRadius.all(medium);
  static const largeBorder = BorderRadius.all(large);
  static const xlargeBorder = BorderRadius.all(xlarge);
  static const badgeBorder = BorderRadius.all(badge);
  static const colorSwatchBorder = BorderRadius.all(colorSwatch);
  static const chipBorder = BorderRadius.all(chip);
  static const toggleBorder = BorderRadius.all(toggle);
  static const zoneSegmentTopBorder = BorderRadius.vertical(top: zoneSegment);
  static const progressBorder = BorderRadius.all(progress);
  static const pillBorder = BorderRadius.all(pill);
  static const screenBorder = BorderRadius.all(screen);
  static const deviceBorder = BorderRadius.all(device);
  static const bottomSheetBorder = BorderRadius.vertical(top: large);
}
