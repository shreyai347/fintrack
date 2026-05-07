import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_routes.dart';
import 'core/config/app_theme.dart';
import 'core/config/locale_notifier.dart';
import 'core/config/theme_mode_notifier.dart';
import 'core/constants/app_strings.dart';
import 'package:fintrack/ui/shell/main_shell.dart';
import 'package:fintrack/features/budget/view/budget_screen.dart';
import 'package:fintrack/features/export/view/export_screen.dart';
import 'package:fintrack/features/receipt/view/camera_screen.dart';
import 'package:fintrack/features/settings/view/settings_screen.dart';
import 'features/transactions/view/add_transaction_screen.dart';
import 'features/transactions/view/edit_transaction_screen.dart';
import 'features/transactions/view/transaction_detail_screen.dart';
import 'features/transactions/view/transaction_screen.dart';
import 'features/transactions/view/transactions_info_screen.dart';
import 'l10n/app_localizations.dart';
import 'ui/splash/splash_page.dart';

class FintrackApp extends ConsumerWidget {
  const FintrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final locale = ref.watch(localeNotifierProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locale,
          onGenerateTitle: (ctx) =>
              AppLocalizations.of(ctx)?.appTitle ?? AppStrings.appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme(lightDynamic),
          darkTheme: AppTheme.darkTheme(darkDynamic),
          themeMode: themeMode,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: (settings) {
            if (settings.name == AppRoutes.transactionDetail) {
              final id = settings.arguments! as int;
              return MaterialPageRoute<void>(
                builder: (_) => TransactionDetailScreen(transactionId: id),
                settings: settings,
              );
            }
            if (settings.name == AppRoutes.editTransaction) {
              final id = settings.arguments! as int;
              return MaterialPageRoute<void>(
                builder: (_) => EditTransactionScreen(transactionId: id),
                settings: settings,
              );
            }
            if (settings.name == AppRoutes.receiptCamera) {
              return MaterialPageRoute<String?>(
                builder: (_) => const CameraScreen(),
                settings: settings,
              );
            }
            return null;
          },
          routes: {
            AppRoutes.splash: (_) => const SplashPage(),
            AppRoutes.dashboard: (_) => const MainShell(),
            AppRoutes.transactions: (_) => const TransactionScreen(),
            AppRoutes.addTransaction: (_) => const AddTransactionScreen(),
            AppRoutes.budget: (_) => const BudgetScreen(),
            AppRoutes.settings: (_) => const SettingsScreen(),
            AppRoutes.export: (_) => const ExportScreen(),
            AppRoutes.transactionsHelp: (_) => const TransactionsInfoScreen(),
          },
        );
      },
    );
  }
}
