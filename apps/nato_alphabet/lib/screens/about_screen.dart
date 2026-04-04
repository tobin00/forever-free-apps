import 'package:flutter/material.dart';
import 'package:shared_app_core/shared_app_core.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AboutPage(
      appName: 'Forever Free: NATO Alphabet',
      iconWidget: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/icon/icon.png',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
