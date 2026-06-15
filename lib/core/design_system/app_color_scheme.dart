import 'package:flutter/material.dart';

import 'app_colors.dart';

extension RunZoneColorScheme on ColorScheme {
  Color get zoneOne => AppColors.blue500;
  Color get zoneTwo => AppColors.green500;
  Color get zoneThree => AppColors.yellow500;
  Color get zoneFour => AppColors.orange500;
  Color get zoneFive => AppColors.red500;

  Color get valueEmphasis => brightness == Brightness.dark ? AppColors.lime300 : AppColors.lime700;
}
