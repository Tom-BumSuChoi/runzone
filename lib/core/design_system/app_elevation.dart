import 'package:flutter/widgets.dart';

import 'app_colors.dart';

abstract final class AppElevation {
  static const shadow = <BoxShadow>[
    BoxShadow(
      color: Color(0xB3000000),
      offset: Offset(0, 18),
      blurRadius: 50,
      spreadRadius: -18,
    ),
  ];

  static const lightShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x40141E0A),
      offset: Offset(0, 14),
      blurRadius: 40,
      spreadRadius: -18,
    ),
  ];

  static const primaryButtonGlow = <BoxShadow>[
    BoxShadow(
      color: AppColors.accentGlow,
      offset: Offset(0, 8),
      blurRadius: 22,
      spreadRadius: -8,
    ),
  ];

  static const startButtonGlow = <BoxShadow>[
    BoxShadow(
      color: AppColors.accentGlow,
      offset: Offset(0, 6),
      blurRadius: 18,
      spreadRadius: -4,
    ),
  ];

  static const accentGlowShadow = <BoxShadow>[
    BoxShadow(color: AppColors.accentGlow, blurRadius: 40),
  ];

  static const lightAccentGlowShadow = <BoxShadow>[
    BoxShadow(color: AppColors.lightAccentGlow, blurRadius: 40),
  ];
}
