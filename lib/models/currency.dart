class Currency {
  final String code;
  final String flag;
  final String name;
  double buyRate; // Foreign -> YER
  double sellRate; // YER -> Foreign
  double apiRate; // USD -> Currency (for Cross-Rates)
  bool isBase;

  Currency({
    required this.code,
    required this.flag,
    required this.name,
    this.buyRate = 0.0,
    this.sellRate = 0.0,
    this.apiRate = 0.0,
    this.isBase = false,
  });

  // Factory to create from Map (for initial list)
  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      code: map['code'] as String,
      flag: map['flag'] as String,
      name: map['name'] as String,
      apiRate: (map['defaultApiRate'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
