import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/currency_provider.dart';
import 'screens/home_screen.dart';
import 'services/supabase_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const TabdilApp());
}

class TabdilApp extends StatelessWidget {
  const TabdilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CurrencyProvider())],
      child: MaterialApp(
        title: 'Tabdil',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.accent,
            brightness: Brightness.dark,
            background: AppColors.background,
            surface: AppColors.cardSurface,
          ),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.cardSurface,
            foregroundColor: AppColors.textPrimary,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
