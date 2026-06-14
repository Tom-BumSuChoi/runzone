import 'package:flutter/material.dart';

final class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: Image.asset(
          isDark ? 'assets/branding/splash_content_dark.png' : 'assets/branding/splash_content_light.png',
        ),
      ),
    );
  }
}
