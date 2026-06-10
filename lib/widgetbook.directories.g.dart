// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:runzone/widgetbook/run_zone_choice_chip_use_cases.dart'
    as _runzone_widgetbook_run_zone_choice_chip_use_cases;
import 'package:runzone/widgetbook/run_zone_progress_indicator_use_cases.dart'
    as _runzone_widgetbook_run_zone_progress_indicator_use_cases;
import 'package:runzone/widgetbook/run_zone_stepper_use_cases.dart'
    as _runzone_widgetbook_run_zone_stepper_use_cases;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookCategory(
    name: 'Design System',
    children: [
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
