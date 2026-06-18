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
import 'package:runzone/widgetbook/run_zone_card_use_cases.dart'
    as _runzone_widgetbook_run_zone_card_use_cases;
import 'package:runzone/widgetbook/run_zone_choice_chip_use_cases.dart'
    as _runzone_widgetbook_run_zone_choice_chip_use_cases;
import 'package:runzone/widgetbook/run_zone_inline_action_button_use_cases.dart'
    as _runzone_widgetbook_run_zone_inline_action_button_use_cases;
import 'package:runzone/widgetbook/run_zone_labels_use_cases.dart'
    as _runzone_widgetbook_run_zone_labels_use_cases;
import 'package:runzone/widgetbook/run_zone_list_item_use_cases.dart'
    as _runzone_widgetbook_run_zone_list_item_use_cases;
import 'package:runzone/widgetbook/run_zone_primary_button_use_cases.dart'
    as _runzone_widgetbook_run_zone_primary_button_use_cases;
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
      _widgetbook.WidgetbookFolder(
        name: 'Badge',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneBadge',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_badge_use_cases
                    .buildBadgeUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Bar',
        children: [
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
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Button',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneInlineActionButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _runzone_widgetbook_run_zone_inline_action_button_use_cases
                        .buildInlineActionButtonUseCase,
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
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Card',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneCard',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_card_use_cases
                    .buildCardUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Chip',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneChoiceChip',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_choice_chip_use_cases
                    .buildChoiceChipUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Control',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneSegmentedControl',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _runzone_widgetbook_run_zone_segmented_control_use_cases
                        .buildSegmentedControlUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Label',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneBodyLargeLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildBodyLargeLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneBodyMediumLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildBodyMediumLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneBodySmallLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildBodySmallLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneDisplayLargeLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildDisplayLargeLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneDisplayMediumLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildDisplayMediumLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneDisplaySmallLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildDisplaySmallLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneHeadlineLargeLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildHeadlineLargeLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneHeadlineMediumLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildHeadlineMediumLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneHeadlineSmallLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildHeadlineSmallLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneLabelLargeLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildLabelLargeLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneLabelMediumLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildLabelMediumLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneLabelSmallLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildLabelSmallLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneTitleLargeLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildTitleLargeLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneTitleMediumLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildTitleMediumLabelUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneTitleSmallLabel',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_labels_use_cases
                    .buildTitleSmallLabelUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'List',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneListItem',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _runzone_widgetbook_run_zone_list_item_use_cases
                    .buildListItemUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Navigation',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneBottomNavigation',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _runzone_widgetbook_run_zone_bottom_navigation_use_cases
                        .buildBottomNavigationUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneBottomNavigationItem',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _runzone_widgetbook_run_zone_bottom_navigation_use_cases
                        .buildBottomNavigationItemUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneBottomNavigationStartButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _runzone_widgetbook_run_zone_bottom_navigation_use_cases
                        .buildBottomNavigationStartButtonUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Progress',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneProgressIndicator',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _runzone_widgetbook_run_zone_progress_indicator_use_cases
                        .buildProgressIndicatorUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'RunZoneRingProgress',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Ring',
                builder:
                    _runzone_widgetbook_run_zone_progress_indicator_use_cases
                        .buildRingProgressUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Slider',
        children: [
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
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Stepper',
        children: [
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
      _widgetbook.WidgetbookFolder(
        name: 'Swatch',
        children: [
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
        ],
      ),
    ],
  ),
];
