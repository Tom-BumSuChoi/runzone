import 'package:flutter/material.dart';
import 'package:runzone/app/di.dart';
import 'package:runzone/app/run_zone_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const RunZoneApp());
}
