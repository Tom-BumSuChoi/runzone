import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/design_system/widgets/navigation/run_zone_bottom_navigation.dart';

@widgetbook.UseCase(name: 'Default', type: RunZoneBottomNavigation, path: '[Design System]')
Widget buildBottomNavigationUseCase(BuildContext context) {
  return const _BottomNavigationDemo();
}

@widgetbook.UseCase(name: 'Selected', type: RunZoneBottomNavigationItem, path: '[Design System]')
Widget buildSelectedBottomNavigationItemUseCase(BuildContext context) {
  return RunZoneBottomNavigationItem(label: '홈', iconAsset: 'assets/icons/home.svg', isSelected: true, onTap: () {});
}

@widgetbook.UseCase(name: 'Unselected', type: RunZoneBottomNavigationItem, path: '[Design System]')
Widget buildUnselectedBottomNavigationItemUseCase(BuildContext context) {
  return RunZoneBottomNavigationItem(label: '홈', iconAsset: 'assets/icons/home.svg', isSelected: false, onTap: () {});
}

@widgetbook.UseCase(name: 'Default', type: RunZoneBottomNavigationStartButton, path: '[Design System]')
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
            iconAsset: 'assets/icons/home.svg',
            isSelected: _selectedIndex == 0,
            onTap: () => setState(() => _selectedIndex = 0),
          ),
          RunZoneBottomNavigationItem(
            label: '플랜',
            iconAsset: 'assets/icons/calendar.svg',
            isSelected: _selectedIndex == 1,
            onTap: () => setState(() => _selectedIndex = 1),
          ),
          RunZoneBottomNavigationStartButton(onTap: () {}),
          RunZoneBottomNavigationItem(
            label: '기록',
            iconAsset: 'assets/icons/activity.svg',
            isSelected: _selectedIndex == 2,
            onTap: () => setState(() => _selectedIndex = 2),
          ),
          RunZoneBottomNavigationItem(
            label: '마이페이지',
            iconAsset: 'assets/icons/user.svg',
            isSelected: _selectedIndex == 3,
            onTap: () => setState(() => _selectedIndex = 3),
          ),
        ],
      ),
    );
  }
}
