import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/design_system/app_sizing.dart';
import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/assets/run_zone_icon_asset.dart';
import '../../../../../core/design_system/widgets/card/run_zone_filled_card.dart';
import '../../../../../core/design_system/widgets/label/run_zone_body_small_label.dart';

final class WorkoutPausedTreadmillHint extends StatelessWidget {
  const WorkoutPausedTreadmillHint({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RunZoneFilledCard(
      child: Row(
        children: [
          SvgPicture.asset(
            RunZoneIconAsset.info.path,
            width: AppSizing.inlineIconSize,
            height: AppSizing.inlineIconSize,
            colorFilter: ColorFilter.mode(colorScheme.onSurfaceVariant, BlendMode.srcIn),
          ),
          AppSpacing.inlineLabelGap,
          Expanded(child: RunZoneBodySmallLabel('러닝머신은 같은 페이스로 이어져요', color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
