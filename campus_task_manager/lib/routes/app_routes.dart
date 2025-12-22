class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String taskList = '/tasks';
  static const String taskDetail = '/task/detail';
  static const String taskForm = '/task/form';
  static const String settings = '/settings';
  
  static const List<String> protectedRoutes = [
    dashboard,
    taskList,
    taskDetail,
    taskForm,
    settings,
  ];
  
  static bool isProtectedRoute(String route) {
    return protectedRoutes.contains(route);
  }
}