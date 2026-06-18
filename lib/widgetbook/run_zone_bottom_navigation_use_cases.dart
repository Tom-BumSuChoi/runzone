import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/assets/run_zone_icon_asset.dart';
import '../core/design_system/widgets/navigation/run_zone_bottom_navigation.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneBottomNavigation, path: '[Design System]/Navigation')
Widget buildBottomNavigationUseCase(BuildContext context) {
  return const _BottomNavigationDemo();
}

@widgetbook.UseCase(name: 'Default', type: RunZoneBottomNavigationItem, path: '[Design System]/Navigation')
Widget buildBottomNavigationItemUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: '홈');
  final isSelected = context.knobs.boolean(label: 'Selected', initialValue: true);

  return RunZoneBottomNavigationItem(
    label: label,
    icon: RunZoneIconAsset.home,
    isSelected: isSelected,
    onTap: () {},
  );
}

@widgetbook.UseCase(name: 'Default', type: RunZoneBottomNavigationStartButton, path: '[Design System]/Navigation')
Widget buildBottomNavigationStartButtonUseCase(BuildContext context) {
  return RunZoneBottomNavigationStartButton(onTap: () {});
}

final class _BottomNavigationDemo extends StatefulWidget {
  const _BottomNavigationDemo();

  @override
  State<_BottomNavigationDemo> createState() => _BottomNavigationDemoState();
}

final class _BottomNavigationDemoState extends State<_BottomNavigationDemo> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: RunZoneBottomNavigation(
        items: [
          RunZoneBottomNavigationItem(
            label: '홈',
            icon: RunZoneIconAsset.home,
            isSelected: _selectedIndex == 0,
            onTap: () => setState(() => _selectedIndex = 0),
          ),
          RunZoneBottomNavigationItem(
            label: '플랜',
            icon: RunZoneIconAsset.calendar,
            isSelected: _selectedIndex == 1,
            onTap: () => setState(() => _selectedIndex = 1),
          ),
          RunZoneBottomNavigationStartButton(onTap: () {}),
          RunZoneBottomNavigationItem(
            label: '기록',
            icon: RunZoneIconAsset.activity,
            isSelected: _selectedIndex == 2,
            onTap: () => setState(() => _selectedIndex = 2),
          ),
          RunZoneBottomNavigationItem(
            label: '마이페이지',
            icon: RunZoneIconAsset.user,
            isSelected: _selectedIndex == 3,
            onTap: () => setState(() => _selectedIndex = 3),
          ),
        ],
      ),
    );
  }
}
