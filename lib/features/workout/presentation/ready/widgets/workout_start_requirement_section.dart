import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/design_system/app_spacing.dart';
import '../../../../../core/design_system/app_sizing.dart';
import '../../../../../core/design_system/assets/run_zone_icon_asset.dart';
import '../../../../../core/design_system/widgets/label/run_zone_body_medium_label.dart';
import '../workout_ready_cubit.dart';

final class WorkoutStartRequirementSection extends StatelessWidget {
  const WorkoutStartRequirementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutReadyCubit, WorkoutReadyState>(
      builder: (context, readyState) {
        final message = switch ((readyState.isHeartRateDeviceConnected, readyState.canStart)) {
          (false, _) => '심박 기기 연결이 필요해요.',
          (true, false) => '러닝머신 연결이 필요해요.',
          (true, true) => null,
        };

        if (message == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [AppSpacing.sectionGap, _WorkoutStartRequirementCard(message)],
        );
      },
    );
  }
}

final class _WorkoutStartRequirementCard extends StatelessWidget {
  const _WorkoutStartRequirementCard(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          RunZoneIconAsset.info.path,
          width: AppSizing.inlineIconSize,
          height: AppSizing.inlineIconSize,
          colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
        ),
        AppSpacing.inlineLabelGap,
        Expanded(child: RunZoneBodyMediumLabel(message)),
      ],
    );
  }
}
