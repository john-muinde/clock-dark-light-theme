import 'package:dark_light_theme/app_theme.dart';
import 'package:dark_light_theme/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screen/home_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLightTheme = prefs.getBool(SPref.isLight) ?? true;
  runApp(AppStart(isLightTheme: isLightTheme));
}

class AppStart extends StatelessWidget {
  const AppStart({super.key, required this.isLightTheme});
  final bool isLightTheme;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(isLightTheme: isLightTheme),
        )
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeProvider.themeData(),
      home: const HomeScreen(),
    );
  }
}
