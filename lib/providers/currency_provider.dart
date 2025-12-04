import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../services/rates_service.dart';
import '../services/supabase_service.dart';
import '../utils/constants.dart';

class CurrencyProvider with ChangeNotifier {
  final RatesService _ratesService = RatesService();
  final SupabaseService _supabaseService = SupabaseService();

  List<Currency> _currencies = [];
  List<Currency> get currencies => _currencies;

  Currency? _selectedCurrency;
  Currency? get selectedCurrency => _selectedCurrency;

  String _inputAmount = '0';
  String get inputAmount => _inputAmount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // API Status tracking
  RatesSource _ratesSource = RatesSource.none;
  RatesSource get ratesSource => _ratesSource;

  String get ratesSourceText {
    switch (_ratesSource) {
      case RatesSource.api:
        return '✅ أسعار API (مباشرة)';
      case RatesSource.supabase:
        return '📦 أسعار محفوظة (Supabase)';
      case RatesSource.defaults:
        return '⚠️ أسعار افتراضية';
      case RatesSource.none:
        return '⏳ جاري التحميل...';
    }
  }

  CurrencyProvider() {
    _initializeCurrencies();
  }

  Future<void> _initializeCurrencies() async {
    _isLoading = true;
    notifyListeners();

    // 1. Load initial list from Constants
    _currencies = CurrencyData.supportedCurrencies
        .map((map) => Currency.fromMap(map))
        .toList();

    // Set default selected (e.g., YER or USD)
    _selectedCurrency = _currencies.firstWhere(
      (c) => c.code == 'USD',
      orElse: () => _currencies.first,
    );

    // 2. Fetch Rates
    await refreshRates();

    _isLoading = false;
    notifyListeners();
  }

  Future<String> refreshRates() async {
    _isLoading = true;
    notifyListeners();

    String statusMessage = '';

    try {
      // Fetch Manual Rates (YER <-> Foreign)
      final manualRates = await _ratesService.fetchManualRates();

      // Fetch API Rates with status (USD -> Foreign)
      final apiResult = await _ratesService.fetchApiRatesWithStatus();
      _ratesSource = apiResult.source;

      statusMessage = ratesSourceText;

      for (var currency in _currencies) {
        // Update Manual Rates
        final manualEntry = manualRates.firstWhere(
          (element) => element['currency_code'] == currency.code,
          orElse: () => {},
        );

        if (manualEntry.isNotEmpty) {
          currency.buyRate = (manualEntry['buy_rate'] as num).toDouble();
          currency.sellRate = (manualEntry['sell_rate'] as num).toDouble();
        }

        // Update API Rates
        if (apiResult.rates.containsKey(currency.code)) {
          currency.apiRate = apiResult.rates[currency.code]!;
        }
      }
    } catch (e) {
      print('Error refreshing rates: $e');
      statusMessage = '❌ خطأ في تحديث الأسعار';
    }

    _isLoading = false;
    notifyListeners();
    return statusMessage;
  }

  void selectCurrency(Currency currency) {
    _selectedCurrency = currency;
    _inputAmount =
        '0'; // Reset input on change? Or keep? Calculator style usually resets or converts.
    // Let's keep it '0' for now as per typical calculator behavior when switching "source" context,
    // OR we could convert the existing value to the new currency.
    // Requirement says "input numbers into the selected currency row".
    // So if I click a row, that becomes the active input row.
    notifyListeners();
  }

  void onKeypadTap(String value) {
    if (value == 'C') {
      _inputAmount = '0';
    } else if (value == '⌫') {
      if (_inputAmount.length > 1) {
        _inputAmount = _inputAmount.substring(0, _inputAmount.length - 1);
      } else {
        _inputAmount = '0';
      }
    } else {
      if (_inputAmount == '0') {
        _inputAmount = value;
      } else {
        _inputAmount += value;
      }
    }
    notifyListeners();
  }

  String getCalculatedAmount(Currency targetCurrency) {
    if (_selectedCurrency == null) return '0';

    double amount = double.tryParse(_inputAmount) ?? 0.0;
    if (amount == 0) return '0';

    if (targetCurrency.code == _selectedCurrency!.code) {
      return _inputAmount;
    }

    double result = 0.0;

    // Hybrid Logic
    if (_selectedCurrency!.code == 'YER') {
      // Scenario A: YER -> Foreign
      // Formula: Amount / Sell_Rate
      if (targetCurrency.sellRate > 0) {
        result = amount / targetCurrency.sellRate;
      }
    } else if (targetCurrency.code == 'YER') {
      // Scenario B: Foreign -> YER
      // Formula: Amount * Buy_Rate
      result = amount * _selectedCurrency!.buyRate;
    } else {
      // Scenario C: Foreign -> Foreign
      // Formula: Amount * (Target_API_Rate / Base_API_Rate)
      // Base here is _selectedCurrency
      if (_selectedCurrency!.apiRate > 0) {
        result = amount * (targetCurrency.apiRate / _selectedCurrency!.apiRate);
      } else {
        print(
          'Warning: apiRate for ${_selectedCurrency!.code} is 0. Cannot calculate cross-rate.',
        );
      }
    }

    // Formatting: Remove decimals if whole number, else show 2-4 decimals
    // User previously asked for "whole numbers" in a past conversation, but let's stick to standard for now
    // unless specified. The prompt says "Calculated Amount".
    // Let's format to 2 decimal places for readability, or maybe 4 for precision.
    return result.toStringAsFixed(2);
  }

  // Admin: Update Rate
  Future<bool> updateRate(String currencyCode, double buy, double sell) async {
    print(
      'CurrencyProvider.updateRate called: code=$currencyCode, buy=$buy, sell=$sell',
    );
    final success = await _supabaseService.updateBackupRate(
      currencyCode,
      buy,
      sell,
    );
    print('CurrencyProvider.updateRate result: $success');
    if (success) {
      await refreshRates(); // Refresh to update UI
    }
    return success;
  }

  // Admin: Update All Rates at once (faster)
  Future<bool> updateAllRates(Map<String, Map<String, double>> rates) async {
    print(
      'CurrencyProvider.updateAllRates called with ${rates.length} currencies',
    );

    bool allSuccess = true;

    for (var entry in rates.entries) {
      final currencyCode = entry.key;
      final buyRate = entry.value['buy'] ?? 0.0;
      final sellRate = entry.value['sell'] ?? 0.0;

      final success = await _supabaseService.updateBackupRate(
        currencyCode,
        buyRate,
        sellRate,
      );

      if (!success) {
        allSuccess = false;
        print('Failed to update $currencyCode');
      }
    }

    // Refresh only once after all updates
    if (allSuccess) {
      // Just update local rates without fetching from API (faster)
      for (var currency in _currencies) {
        if (rates.containsKey(currency.code)) {
          currency.buyRate = rates[currency.code]!['buy'] ?? currency.buyRate;
          currency.sellRate =
              rates[currency.code]!['sell'] ?? currency.sellRate;
        }
      }
      notifyListeners();
    }

    print('CurrencyProvider.updateAllRates result: $allSuccess');
    return allSuccess;
  }
}
