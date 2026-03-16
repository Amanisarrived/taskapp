import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static const String tasksTable = 'tasks';
  static const String appName = 'TaskHub';

  static const String routeLogin = '/login';
  static const String routeSignup = '/signup';
  static const String routeDashboard = '/dashboard';

  static const String prefThemeMode = 'theme_mode';

  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration animFast = Duration(milliseconds: 250);
  static const Duration animMedium = Duration(milliseconds: 400);
}