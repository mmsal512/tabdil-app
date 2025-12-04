import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  /// Authenticate Admin
  Future<bool> authenticateAdmin(String username, String password) async {
    try {
      final response = await _client
          .from(AppConstants.tableAdmins)
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
      final response = await _client
          .from(AppConstants.tableBackupRates)
          .select();
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
      await _client.from(AppConstants.tableBackupRates).upsert({
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
          .from(AppConstants.tableHistoricalRates)
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
      // We'll upsert based on a fixed base_currency 'USD' or just insert a new row.
      // Assuming the table has a unique constraint or we just want to keep the latest.
      // Let's assume we update the row where base_currency = 'USD'.
      await _client.from(AppConstants.tableHistoricalRates).upsert({
        'base_currency': 'USD',
        'rates': rates,
        // Add timestamp if column exists, e.g., 'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Save Historical Rates Error: $e');
    }
  }
}
