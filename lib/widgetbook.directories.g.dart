// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:runzone/widgetbook/color_swatch_use_cases.dart'
    as _runzone_widgetbook_color_swatch_use_cases;
import 'package:runzone/widgetbook/heart_rate_zone_adjustment_screen_use_cases.dart'
    as _runzone_widgetbook_heart_rate_zone_adjustment_screen_use_cases;
import 'package:runzone/widgetbook/labeled_slider_use_cases.dart'
    as _runzone_widgetbook_labeled_slider_use_cases;
import 'package:runzone/widgetbook/run_zone_badge_use_cases.dart'
    as _runzone_widgetbook_run_zone_badge_use_cases;
import 'package:runzone/widgetbook/run_zone_bottom_navigation_use_cases.dart'
    as _runzone_widgetbook_run_zone_bottom_navigation_use_cases;
import 'package:runzone/widgetbook/run_zone_choice_chip_use_cases.dart'
    as _runzone_widgetbook_run_zone_choice_chip_use_cases;
import 'package:runzone/widgetbook/run_zone_primary_button_use_cases.dart'
    as _runzone_widgetbook_run_zone_primary_button_use_cases;
import 'package:runzone/widgetbook/run_zone_profile_field_use_cases.dart'
    as _runzone_widgetbook_run_zone_profile_field_use_cases;
import 'package:runzone/widgetbook/run_zone_progress_indicator_use_cases.dart'
    as _runzone_widgetbook_run_zone_progress_indicator_use_cases;
import 'package:runzone/widgetbook/run_zone_segmented_control_use_cases.dart'
    as _runzone_widgetbook_run_zone_segmented_control_use_cases;
import 'package:runzone/widgetbook/run_zone_stepper_use_cases.dart'
    as _runzone_widgetbook_run_zone_stepper_use_cases;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookCategory(
    name: 'Design System',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'RunZoneBadge',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _runzone_widgetbook_run_zone_badge_use_cases.buildBadgeUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RunZoneBottomNavigation',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _runzone_widgetbook_run_zone_bottom_navigation_use_cases
                .buildBottomNavigationUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RunZoneBottomNavigationItem',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Selected',
            builder: _runzone_widgetbook_run_zone_bottom_navigation_use_cases
                .buildSelectedBottomNavigationItemUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Unselected',
            builder: _runzone_widgetbook_run_zone_bottom_navigation_use_cases
                .buildUnselectedBottomNavigationItemUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RunZoneBottomNavigationStartButton',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _runzone_widgetbook_run_zone_bottom_navigation_use_cases
                .buildBottomNavigationStartButtonUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RunZoneChoiceChip',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Selected',
            builder: _runzone_widgetbook_run_zone_choice_chip_use_cases
                .buildSelectedChoiceChipUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Unselected',
            builder: _runzone_widgetbook_run_zone_choice_chip_use_cases
                .buildUnselectedChoiceChipUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RunZoneColorSwatch',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _runzone_widgetbook_color_swatch_use_cases
                .buildColorSwatchUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RunZoneLabeledSlider',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _runzone_widgetbook_labeled_slider_use_cases
                .buildLabeledSliderUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RunZonePrimaryButton',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _runzone_widgetbook_run_zone_primary_button_use_cases
                .buildPrimaryButtonUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RunZoneProfileField',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'With Chips',
            builder: _runzone_widgetbook_run_zone_profile_field_use_cases
                .buildProfileFieldWithChipsUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'With Stepper',
            builder: _runzone_widgetbook_run_zone_profile_field_use_cases
                .buildProfileFieldWithStepperUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RunZoneProgressIndicator',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Step 1 of 2',
            builder: _runzone_widgetbook_run_zone_progress_indicator_use_cases
                .buildStepOneProgressIndicatorUseCase,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Step 2 of 2',
            builder: _runzone_widgetbook_run_zone_progress_indicator_use_cases
                .buildStepTwoProgressIndicatorUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RunZoneSegmentedBar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _runzone_widgetbook_heart_rate_zone_adjustment_screen_use_cases
                    .buildHeartRateZoneBarUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RunZoneSegmentedControl',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _runzone_widgetbook_run_zone_segmented_control_use_cases
                .buildSegmentedControlUseCase,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'RunZoneStepper',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _runzone_widgetbook_run_zone_stepper_use_cases
                .buildStepperUseCase,
          ),
        ],
      ),
    ],
  ),
];
