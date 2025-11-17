import 'package:flutter/material.dart';
import 'home_page.dart';
import 'shared_preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
  runApp(const CampusFeedbackApp());
}

class CampusFeedbackApp extends StatefulWidget {
  const CampusFeedbackApp({super.key});

  @override
  State<CampusFeedbackApp> createState() => _CampusFeedbackAppState();
}

class _CampusFeedbackAppState extends State<CampusFeedbackApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    bool isDark = await SharedPreferencesService.isDarkMode();
    setState(() {
      _isDarkMode = isDark;
    });
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    SharedPreferencesService.setDarkMode(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Feedback',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleDarkMode,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}