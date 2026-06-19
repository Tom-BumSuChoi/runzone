import 'package:flutter/material.dart';

import '../../../../../core/design_system/assets/run_zone_icon_asset.dart';
import '../../../../../core/design_system/widgets/button/run_zone_icon_outline_button.dart';
import '../../../../../core/design_system/widgets/label/run_zone_headline_large_label.dart';

final class WorkoutReadyHeader extends StatelessWidget {
  const WorkoutReadyHeader({super.key, required this.onClosePressed});

  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: RunZoneHeadlineLargeLabel('운동 전 설정')),
        RunZoneIconOutlineButton(icon: RunZoneIconAsset.close, onPressed: onClosePressed),
      ],
    );
  }
}
