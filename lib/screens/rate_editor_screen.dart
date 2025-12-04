import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../utils/constants.dart';

class RateEditorScreen extends StatefulWidget {
  const RateEditorScreen({super.key});

  @override
  State<RateEditorScreen> createState() => _RateEditorScreenState();
}

class _RateEditorScreenState extends State<RateEditorScreen> {
  final Map<String, TextEditingController> _buyControllers = {};
  final Map<String, TextEditingController> _sellControllers = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initControllers();
    });
  }

  void _initControllers() {
    final provider = Provider.of<CurrencyProvider>(context, listen: false);
    for (var currency in provider.currencies) {
      if (currency.code != 'YER') {
        _buyControllers[currency.code] = TextEditingController(
          text: currency.buyRate.toString(),
        );
        _sellControllers[currency.code] = TextEditingController(
          text: currency.sellRate.toString(),
        );
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in _buyControllers.values) {
      controller.dispose();
    }
    for (var controller in _sellControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveAllRates() async {
    setState(() => _isSaving = true);

    final provider = Provider.of<CurrencyProvider>(context, listen: false);

    // Collect all rates to update
    final Map<String, Map<String, double>> ratesToUpdate = {};

    for (var currency in provider.currencies) {
      if (currency.code != 'YER') {
        final buyController = _buyControllers[currency.code];
        final sellController = _sellControllers[currency.code];

        if (buyController != null && sellController != null) {
          ratesToUpdate[currency.code] = {
            'buy': double.tryParse(buyController.text) ?? 0.0,
            'sell': double.tryParse(sellController.text) ?? 0.0,
          };
        }
      }
    }

    // Save all rates
    final success = await provider.updateAllRates(ratesToUpdate);

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'تم حفظ جميع الأسعار بنجاح!'
                : 'فشل في حفظ الأسعار. تحقق من الاتصال.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Rates'),
        backgroundColor: AppColors.cardSurface,
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && _buyControllers.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: provider.currencies.length,
                  itemBuilder: (context, index) {
                    final currency = provider.currencies[index];
                    if (currency.code == 'YER') {
                      return const SizedBox.shrink();
                    }

                    final buyController = _buyControllers[currency.code];
                    final sellController = _sellControllers[currency.code];

                    if (buyController == null || sellController == null) {
                      return const SizedBox.shrink();
                    }

                    return Card(
                      color: AppColors.cardSurface,
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  currency.flag,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${currency.name} (${currency.code})',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: buyController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Buy Rate',
                                      labelStyle: TextStyle(
                                        color: AppColors.textSecondary,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.accent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: sellController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Sell Rate',
                                      labelStyle: TextStyle(
                                        color: AppColors.textSecondary,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.accent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // زر الحفظ الموحد
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isSaving ? null : _saveAllRates,
                  child: _isSaving
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'حفظ جميع الأسعار',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
