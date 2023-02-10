import 'package:dark_light_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants/constants.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeProvider(
        isLightTheme: true,
      ).themeData(),
      home: const HomeScreen(),
    );
  }
}
