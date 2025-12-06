import 'package:flutter/material.dart';

/// Application UI Colors
class AppColors {
  static const Color background = Colors.black;
  static const Color cardSurface = Color(0xFF1E1E1E); // Dark Grey
  static const Color accent = Color(0xFFFF9800); // Orange
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey;
}

/// Supported Currencies Data
/// Note: API keys and URLs are now loaded from runtime config (AppConfig)
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
