import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/config/app_routes.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/features/budget/view/budget_screen.dart';
import 'package:fintrack/features/budget/viewmodel/budget_provider.dart';
import 'package:fintrack/features/dashboard/view/dashboard_screen.dart';
import 'package:fintrack/features/settings/view/settings_screen.dart';
import 'package:fintrack/features/transactions/view/add_transaction_screen.dart';
import 'package:fintrack/features/transactions/view/transaction_screen.dart';
import 'package:fintrack/features/transactions/viewmodel/transaction_provider.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _tab = 0;

  final List<Color> _selectedColors = [
    const Color(0xff5B5FEF),
    const Color(0xff00A86B),
    const Color(0xffF59E0B),
    const Color(0xffEF4444),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appBarTitles = [
      l10n.navHome,
      l10n.transactions,
      l10n.navBudget,
      l10n.navMore,
    ];
    final overlayOpen = ref.watch(addTransactionOverlayVisibleProvider);

    return Scaffold(
      extendBody: true,
      appBar: _tab == 0 || overlayOpen
          ? null
          : AppBar(
              title: Text(appBarTitles[_tab]),
              actions: _tab == 1
                  ? [
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: l10n.transactionsHelpTitle,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.transactionsHelp);
                        },
                      ),
                    ]
                  : null,
            ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          IndexedStack(
            index: _tab,
            children: [
              DashboardScreen(
                onProfileTap: () => setState(() => _tab = 3),
              ),
              const TransactionScreen(embedded: true),
              const BudgetScreen(embedded: true),
              const SettingsScreen(),
            ],
          ),
          if (overlayOpen)
            AddTransactionScaffold(
              onClose: () {
                ref.read(addTransactionWizardProvider.notifier).reset();
                ref.read(addTransactionOverlayVisibleProvider.notifier).hide();
              },
            ),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 68,
        width: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [
              Color(0xff7C5CFF),
              Color(0xff5B5FEF),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff5B5FEF).withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            openAddTransactionOverlay(ref);
          },
          child: const Icon(
            Icons.add,
            size: 34,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 82,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(26),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                icon: Icons.home_rounded,
                label: l10n.navHome,
                index: 0,
              ),
              _navItem(
                icon: Icons.receipt_long_rounded,
                label: l10n.navTxns,
                index: 1,
              ),
              const SizedBox(width: 40),
              _navItem(
                icon: Icons.pie_chart_rounded,
                label: l10n.navBudget,
                index: 2,
              ),
              _navItem(
                icon: Icons.more_horiz_rounded,
                label: l10n.navMore,
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _tab == index;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final unselected = dark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF475569);

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (ref.read(addTransactionOverlayVisibleProvider)) {
            ref.read(addTransactionWizardProvider.notifier).reset();
            ref.read(addTransactionOverlayVisibleProvider.notifier).hide();
          }
          setState(() => _tab = index);
          if (index == 2) {
            ref.read(budgetNotifierProvider.notifier).refresh();
          }
        },
        child: SizedBox(
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 220),
                scale: isSelected ? 1.15 : 1,
                child: Icon(
                  icon,
                  size: 26,
                  color: isSelected ? _selectedColors[index] : unselected,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? _selectedColors[index] : unselected,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}