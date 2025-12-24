import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration loaded from environment variables
class AppConfig {
  // User Management API (Authentication)
  // Production API URL
  static String get authApiBaseUrl =>
      dotenv.env['AUTH_API_BASE_URL'] ??
      'https://usermanagementapi.poultrycore.com';

  // Farm API (Customer,Flock, Dashboard, etc.)
  // Production API URL
  static String get farmApiBaseUrl =>
      dotenv.env['FARM_API_BASE_URL'] ?? 'https://farmapi.poultrycore.com';

  // Environment
  static String get nodeEnv => dotenv.env['NODE_ENV'] ?? 'production';

  /// Initialize the config by loading the .env file
  /// If .env doesn't exist, it will use the defaults above
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // .env file not found, will use defaults
      print('Warning: .env file not found, using default configuration');
    }
  }
}
