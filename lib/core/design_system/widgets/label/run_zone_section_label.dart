import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_typography.dart';

final class RunZoneSectionLabel extends StatelessWidget {
  const RunZoneSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTypography.eyebrow.copyWith(color: AppColors.gray500));
  }
}
