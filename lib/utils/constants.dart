import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Colors.black;
  static const Color cardSurface = Color(0xFF1E1E1E); // Dark Grey
  static const Color accent = Color(0xFFFF9800); // Orange
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey;
}

class AppConstants {
  // Supabase
  static const String supabaseUrl = 'https://hwhmrgplcbhyzfjnxymi.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3aG1yZ3BsY2JoeXpmam54eW1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ4NDA2MDksImV4cCI6MjA4MDQxNjYwOX0.K9GFrpKEP9FVM_7h5VenXRABGQVNi90s4wB_LKSpfF0';

  // Open Exchange Rates API
  static const String openExchangeRatesAppId =
      'd81f75e2194e486da9e3cc870c183f9b';
  static const String exchangeRateApiUrl =
      'https://openexchangerates.org/api/latest.json?app_id=$openExchangeRatesAppId';

  // Table Names
  static const String tableBackupRates = 'backup_rates';
  static const String tableHistoricalRates = 'historical_rates';
  static const String tableAdmins = 'admins';
}

class CurrencyData {
  static const List<Map<String, dynamic>> supportedCurrencies = [
    {
      'code': 'YER',
      'flag': '🇾🇪',
      'name': 'ريال يمني',
      'defaultApiRate': 250.0,
    },
    {
      'code': 'USD',
      'flag': '🇺🇸',
      'name': 'دولار أمريكي',
      'defaultApiRate': 1.0,
    },
    {
      'code': 'SAR',
      'flag': '🇸🇦',
      'name': 'ريال سعودي',
      'defaultApiRate': 3.75,
    },
    {
      'code': 'AED',
      'flag': '🇦🇪',
      'name': 'درهم إماراتي',
      'defaultApiRate': 3.6725,
    },
    {
      'code': 'KWD',
      'flag': '🇰🇼',
      'name': 'دينار كويتي',
      'defaultApiRate': 0.308,
    },
    {
      'code': 'OMR',
      'flag': '🇴🇲',
      'name': 'ريال عماني',
      'defaultApiRate': 0.385,
    },
  ];
}
