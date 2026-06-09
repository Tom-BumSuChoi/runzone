import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'core/design_system/widgets/run_zone_choice_chip.dart';

void main() {
  runApp(const RunZoneCatalogApp());
}

final class RunZoneCatalogApp extends StatelessWidget {
  const RunZoneCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(directories: _catalogDirectories);
  }
}

const String _designSystemCategoryName = 'Design System';
const String _choiceChipComponentName = 'RunZoneChoiceChip';

const String _defaultUseCaseName = 'Default';
const String _selectedUseCaseName = 'Selected';
const String _unselectedUseCaseName = 'Unselected';
const String _disabledUseCaseName = 'Disabled';

const String _labelDefault = '초보';
const String _labelEntry = '입문';
const String _labelDisabled = '비활성';

final List<WidgetbookNode> _catalogDirectories = <WidgetbookNode>[_buildDesignSystemCategory()];

WidgetbookCategory _buildDesignSystemCategory() {
  return WidgetbookCategory(
    name: _designSystemCategoryName,
    children: <WidgetbookNode>[_buildRunZoneChoiceChipComponent()],
  );
}

WidgetbookComponent _buildRunZoneChoiceChipComponent() {
  return WidgetbookComponent(
    name: _choiceChipComponentName,
    useCases: <WidgetbookUseCase>[
      _buildDefaultChoiceChipUseCase(),
      _buildSelectedChoiceChipUseCase(),
      _buildUnselectedChoiceChipUseCase(),
      _buildDisabledChoiceChipUseCase(),
    ],
  );
}

WidgetbookUseCase _buildDefaultChoiceChipUseCase() {
  return WidgetbookUseCase(
    name: _defaultUseCaseName,
    builder: (context) => _buildCenteredChoiceChip(
      label: context.knobs.string(label: 'Label', initialValue: _labelDefault),
      selected: context.knobs.boolean(label: 'Selected', initialValue: false),
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
    ),
  );
}

WidgetbookUseCase _buildSelectedChoiceChipUseCase() {
  return WidgetbookUseCase(
    name: _selectedUseCaseName,
    builder: (_) => _buildCenteredChoiceChip(label: _labelDefault, selected: true, enabled: true),
  );
}

WidgetbookUseCase _buildUnselectedChoiceChipUseCase() {
  return WidgetbookUseCase(
    name: _unselectedUseCaseName,
    builder: (_) => _buildCenteredChoiceChip(label: _labelEntry, selected: false, enabled: true),
  );
}

WidgetbookUseCase _buildDisabledChoiceChipUseCase() {
  return WidgetbookUseCase(
    name: _disabledUseCaseName,
    builder: (_) => _buildCenteredChoiceChip(label: _labelDisabled, selected: false, enabled: false),
  );
}

Widget _buildCenteredChoiceChip({required String label, required bool selected, required bool enabled}) {
  return Center(
    child: RunZoneChoiceChip(label: label, selected: selected, enabled: enabled, onSelected: (_) {}),
  );
}
