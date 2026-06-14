import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'core/design_system/app_theme.dart';
import 'widgetbook.directories.g.dart';

void main() {
  runApp(const RunZoneCatalogApp());
}

@widgetbook.App()
final class RunZoneCatalogApp extends StatelessWidget {
  const RunZoneCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Dark', data: AppTheme.dark),
            WidgetbookTheme(name: 'Light', data: AppTheme.light),
          ],
        ),
        BuilderAddon(
          name: 'Center',
          builder: (context, child) => Center(child: child),
        ),
      ],
      directories: directories,
    );
  }
}
