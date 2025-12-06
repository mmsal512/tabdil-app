import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_config.dart';
import 'supabase_service.dart';

enum RatesSource { api, supabase, defaults, none }

class RatesResult {
  final Map<String, double> rates;
  final RatesSource source;
  final String? errorMessage;

  RatesResult({required this.rates, required this.source, this.errorMessage});
}

class RatesService {
  final SupabaseService _supabaseService = SupabaseService();

  /// Fetch rates from External API (Primary for Foreign-Foreign)
  /// If fails, falls back to Supabase Historical Rates.
  Future<RatesResult> fetchApiRatesWithStatus() async {
    try {
      final apiUrl = AppConfig.exchangeRateApiUrl;
      print('Fetching API Rates from: $apiUrl');

      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Open Exchange Rates format: { "rates": { "USD": 1, "SAR": 3.75, ... } }
        if (data['rates'] != null) {
          final rates = Map<String, double>.from(
            (data['rates'] as Map).map(
              (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
            ),
          );

          print('✅ API Rates Fetched Successfully: ${rates.length} currencies');

          // Cache these rates to Supabase
          await _supabaseService.saveHistoricalRates(rates);

          return RatesResult(rates: rates, source: RatesSource.api);
        } else if (data['error'] != null) {
          print('❌ API Error: ${data['message'] ?? data['description']}');
          return await _fetchHistoricalRatesFromSupabase();
        } else {
          print('❌ Unknown API Response Format');
          return await _fetchHistoricalRatesFromSupabase();
        }
      } else {
        print('❌ API HTTP Error: ${response.statusCode}');
        return await _fetchHistoricalRatesFromSupabase();
      }
    } catch (e) {
      print('❌ API Exception: $e. Falling back to Supabase.');
      return await _fetchHistoricalRatesFromSupabase();
    }
  }

  // Keep old method for backward compatibility
  Future<Map<String, double>> fetchApiRates() async {
    final result = await fetchApiRatesWithStatus();
    return result.rates;
  }

  Future<RatesResult> _fetchHistoricalRatesFromSupabase() async {
    final ratesJson = await _supabaseService.getHistoricalRates();
    if (ratesJson != null && ratesJson.isNotEmpty) {
      print('📦 Loaded Historical Rates from Supabase');
      return RatesResult(
        rates: Map<String, double>.from(
          ratesJson.map((k, v) => MapEntry(k, v.toDouble())),
        ),
        source: RatesSource.supabase,
      );
    }
    print('⚠️ No Historical Rates found - using defaults');
    return RatesResult(
      rates: {},
      source: RatesSource.defaults,
      errorMessage: 'Using default rates',
    );
  }

  /// Fetch Manual Rates (Backup Rates) for YER
  Future<List<Map<String, dynamic>>> fetchManualRates() async {
    return await _supabaseService.getBackupRates();
  }
}
