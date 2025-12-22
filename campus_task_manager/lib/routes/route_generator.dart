import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/task/task_list_screen.dart';
import '../screens/task/task_detail_screen.dart';
import '../screens/task/task_form_screen.dart';
import '../screens/settings_screen.dart';
import '../models/task.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    
    switch (settings.name) {
      case AppRoutes.splash:
        return _fadeRoute(const SplashScreen(), settings);
      
      case AppRoutes.login:
        return _fadeRoute(const LoginScreen(), settings);
      
      case AppRoutes.register:
        return _fadeRoute(const RegisterScreen(), settings);
      
      case AppRoutes.dashboard:
        return _fadeRoute(const DashboardScreen(), settings);
      
      case AppRoutes.taskList:
        return _fadeRoute(const TaskListScreen(), settings);
      
      case AppRoutes.taskDetail:
        if (args is Task) {
          return _fadeRoute(TaskDetailScreen(task: args), settings);
        }
        return _errorRoute();
      
      case AppRoutes.taskForm:
        if (args is Task) {
          return _fadeRoute(TaskFormScreen(task: args), settings);
        }
        return _fadeRoute(const TaskFormScreen(), settings);
      
      case AppRoutes.settings:
        return _fadeRoute(const SettingsScreen(), settings);
      
      default:
        return _errorRoute();
    }
  }
  
  static PageRouteBuilder<dynamic> _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
  
  
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Halaman tidak ditemukan'),
        ),
      ),
    );
  }
}