import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../utils/constants.dart';
import '../widgets/hyper_ui.dart';

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
      body: Stack(
        children: [
          // Animated Background
          const MorphicBackground(),

          // Content
          SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Edit Rates',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // List
                Expanded(
                  child: Consumer<CurrencyProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading && _buyControllers.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.currencies.length,
                        itemBuilder: (context, index) {
                          final currency = provider.currencies[index];
                          if (currency.code == 'YER') {
                            return const SizedBox.shrink();
                          }

                          final buyController = _buyControllers[currency.code];
                          final sellController =
                              _sellControllers[currency.code];

                          if (buyController == null || sellController == null) {
                            return const SizedBox.shrink();
                          }

                          return GlassContainer(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      currency.flag,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${currency.name} (${currency.code})',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GlassTextField(
                                        controller: buyController,
                                        label: 'Buy Rate',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: GlassTextField(
                                        controller: sellController,
                                        label: 'Sell Rate',
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Save Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NeonButton(
                    text: 'حفظ جميع الأسعار',
                    onPressed: _saveAllRates,
                    isLoading: _isSaving,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
