import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Runtime configuration loaded from assets/config.json
/// This file is generated at container startup from Docker secrets
class AppConfig {
  static late Map<String, dynamic> _config;
  static bool _initialized = false;

  /// Load configuration from config.json
  /// Call this before runApp() in main.dart
  static Future<void> load() async {
    if (_initialized) return;

    try {
      final jsonStr = await rootBundle.loadString('config.json');
      _config = jsonDecode(jsonStr) as Map<String, dynamic>;
      _initialized = true;
      print('✅ Runtime config loaded successfully');
    } catch (e) {
      print('⚠️ Failed to load config.json: $e');
      print('   Using fallback hardcoded values (development only)');

      // Fallback for development - DO NOT use in production
      _config = {
        'SUPABASE_URL': 'https://hwhmrgplcbhyzfjnxymi.supabase.co',
        'SUPABASE_ANON_KEY':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3aG1yZ3BsY2JoeXpmam54eW1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ4NDA2MDksImV4cCI6MjA4MDQxNjYwOX0.K9GFrpKEP9FVM_7h5VenXRABGQVNi90s4wB_LKSpfF0',
        'OPEN_EXCHANGE_API_KEY': 'd81f75e2194e486da9e3cc870c183f9b',
        'APP_ENV': 'development',
      };
      _initialized = true;
    }
  }

  /// Get Supabase URL
  static String get supabaseUrl => _config['SUPABASE_URL'] ?? '';

  /// Get Supabase Anonymous Key
  static String get supabaseAnonKey => _config['SUPABASE_ANON_KEY'] ?? '';

  /// Get Open Exchange Rates API Key
  static String get openExchangeApiKey =>
      _config['OPEN_EXCHANGE_API_KEY'] ?? '';

  /// Get current environment (production/development)
  static String get appEnv => _config['APP_ENV'] ?? 'development';

  /// Check if running in production
  static bool get isProduction => appEnv == 'production';

  /// Get the full API URL for Open Exchange Rates
  static String get exchangeRateApiUrl =>
      'https://openexchangerates.org/api/latest.json?app_id=$openExchangeApiKey';
}
