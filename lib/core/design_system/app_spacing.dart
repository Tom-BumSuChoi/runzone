import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const cardPadding = 16.0;
  static const screenPadding = 20.0;
  static const buttonPaddingVertical = 13.0;
  static const buttonPaddingHorizontal = 18.0;
  static const chipPaddingVertical = 8.0;
  static const chipPaddingHorizontal = 14.0;
  static const badgePaddingVertical = 4.0;
  static const badgePaddingHorizontal = 10.0;
  static const segmentedControlPadding = 4.0;
  static const segmentedControlButtonPaddingVertical = 10.0;
  static const controlBarPadding = 10.0;
  static const navigationPaddingTop = 12.0;
  static const navigationPaddingHorizontal = 14.0;
  static const navigationStartButtonLift = 6.0;

  static const chipGap = 8.0;
  static const controlGroupGap = 14.0;
  static const controlLabelGap = 6.0;
  static const segmentedControlGap = 4.0;
  static const stepperGap = 12.0;
  static const progressSegmentGap = 6.0;
  static const zoneSegmentGap = 4.0;

  static const inlineLabelGap = SizedBox(width: 6);
  static const inlineValueGap = SizedBox(width: 4);
  static const navigationLabelGap = SizedBox(height: 6);
  static const controlGroupSpacer = SizedBox(height: controlGroupGap);
  static const sectionGap = SizedBox(height: 18);
  static const sectionLabelGap = SizedBox(height: 6);
  static const headerTitleGap = SizedBox(height: 22);
  static const titleDescriptionGap = SizedBox(height: 6);
  static const metricLabelGap = SizedBox(height: 2);
  static const headlineTagGap = SizedBox(height: 14);
  static const footerHintGap = SizedBox(height: 10);

  static const cardInsets = EdgeInsets.all(cardPadding);
  static const screenInsets = EdgeInsets.all(screenPadding);
  static const buttonInsets = EdgeInsets.symmetric(
    vertical: buttonPaddingVertical,
    horizontal: buttonPaddingHorizontal,
  );
  static const badgeInsets = EdgeInsets.symmetric(vertical: badgePaddingVertical, horizontal: badgePaddingHorizontal);
  static const chipInsets = EdgeInsets.symmetric(vertical: chipPaddingVertical, horizontal: chipPaddingHorizontal);
  static const segmentedControlInsets = EdgeInsets.all(segmentedControlPadding);
  static const segmentedControlButtonInsets = EdgeInsets.symmetric(vertical: segmentedControlButtonPaddingVertical);
  static const navigationInsets = EdgeInsets.fromLTRB(
    navigationPaddingHorizontal,
    navigationPaddingTop,
    navigationPaddingHorizontal,
    0,
  );
}
