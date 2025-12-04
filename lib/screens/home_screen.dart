import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../utils/constants.dart';
import 'admin_login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardSurface,
        title: const Text(
          'Tabdil',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.accent),
            onPressed: () async {
              final provider = Provider.of<CurrencyProvider>(
                context,
                listen: false,
              );
              final statusMessage = await provider.refreshRates();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(statusMessage),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.textSecondary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminLoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Bar
          Consumer<CurrencyProvider>(
            builder: (context, provider, child) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: AppColors.cardSurface,
                child: Text(
                  provider.ratesSourceText,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          // Currency List
          Expanded(
            child: Consumer<CurrencyProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  );
                }
                return ListView.builder(
                  itemCount: provider.currencies.length,
                  itemBuilder: (context, index) {
                    final currency = provider.currencies[index];
                    final isSelected =
                        provider.selectedCurrency?.code == currency.code;
                    final amount = provider.getCalculatedAmount(currency);

                    return GestureDetector(
                      onTap: () => provider.selectCurrency(currency),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.cardSurface.withOpacity(0.8)
                              : AppColors.cardSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: AppColors.accent, width: 2)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Text(
                              currency.flag,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currency.code,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  currency.name,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              amount,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Keypad
          const Keypad(),
        ],
      ),
    );
  }
}

class Keypad extends StatelessWidget {
  const Keypad({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardSurface,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _buildButton(context, '7'),
              _buildButton(context, '8'),
              _buildButton(context, '9'),
            ],
          ),
          Row(
            children: [
              _buildButton(context, '4'),
              _buildButton(context, '5'),
              _buildButton(context, '6'),
            ],
          ),
          Row(
            children: [
              _buildButton(context, '1'),
              _buildButton(context, '2'),
              _buildButton(context, '3'),
            ],
          ),
          Row(
            children: [
              _buildButton(context, 'C', color: Colors.red),
              _buildButton(context, '0'),
              _buildButton(context, '⌫', color: AppColors.accent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.background,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Provider.of<CurrencyProvider>(
              context,
              listen: false,
            ).onKeypadTap(label);
          },
          child: Text(
            label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
