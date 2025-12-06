import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // Table Names
  static const String tableBackupRates = 'backup_rates';
  static const String tableHistoricalRates = 'historical_rates';
  static const String tableAdmins = 'admins';

  SupabaseClient get _client => Supabase.instance.client;

  /// Initialize Supabase with runtime configuration
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    print('✅ Supabase initialized with URL: ${AppConfig.supabaseUrl}');
  }

  /// Authenticate Admin
  Future<bool> authenticateAdmin(String username, String password) async {
    try {
      final response = await _client
          .from(tableAdmins)
          .select()
          .eq('username', username)
          .eq('password', password)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Auth Error: $e');
      return false;
    }
  }

  /// Get Backup Rates (Manual Rates)
  Future<List<Map<String, dynamic>>> getBackupRates() async {
    try {
      final response = await _client.from(tableBackupRates).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get Backup Rates Error: $e');
      return [];
    }
  }

  /// Update Backup Rate
  Future<bool> updateBackupRate(
    String currencyCode,
    double buyRate,
    double sellRate,
  ) async {
    try {
      // Using upsert with onConflict to ensure we update the existing row for the currency
      await _client.from(tableBackupRates).upsert({
        'currency_code': currencyCode,
        'buy_rate': buyRate,
        'sell_rate': sellRate,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'currency_code');
      return true;
    } catch (e) {
      print('Update Rate Error: $e');
      if (e is PostgrestException) {
        print('Postgrest Error Code: ${e.code}');
        print('Postgrest Error Message: ${e.message}');
        print('Postgrest Error Details: ${e.details}');
        print('Postgrest Error Hint: ${e.hint}');
      }
      return false;
    }
  }

  /// Get Historical Rates (Cached API Rates)
  Future<Map<String, dynamic>?> getHistoricalRates() async {
    try {
      final response = await _client
          .from(tableHistoricalRates)
          .select()
          .limit(1)
          .maybeSingle();

      if (response != null && response['rates'] != null) {
        return response['rates'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Get Historical Rates Error: $e');
      return null;
    }
  }

  /// Save Historical Rates (Cache API Rates)
  Future<void> saveHistoricalRates(Map<String, double> rates) async {
    try {
      await _client.from(tableHistoricalRates).upsert({
        'base_currency': 'USD',
        'rates': rates,
      });
    } catch (e) {
      print('Save Historical Rates Error: $e');
    }
  }
}
