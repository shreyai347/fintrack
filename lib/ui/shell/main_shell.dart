import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/features/budget/view/budget_screen.dart';
import 'package:fintrack/features/dashboard/view/dashboard_screen.dart';
import 'package:fintrack/features/transactions/view/add_transaction_screen.dart';
import 'package:fintrack/features/transactions/view/transaction_screen.dart';
import 'package:fintrack/features/settings/view/settings_screen.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _tab = 0;

  int _bottomIndexForTab(int tab) => tab < 2 ? tab : tab + 1;

  int _tabForBottomIndex(int bottomIndex) {
    if (bottomIndex < 2) return bottomIndex;
    return bottomIndex - 1;
  }

  @override
  Widget build(BuildContext context) {
    final showFab = _tab == 0 || _tab == 1;
    final titles = [
      AppStrings.navDashboard,
      AppStrings.navTransactions,
      AppStrings.navBudget,
      AppStrings.navSettings,
    ];

    return Scaffold(
      appBar: _tab == 0
          ? null
          : AppBar(
              title: Text(titles[_tab]),
            ),
      body: IndexedStack(
        index: _tab,
        children: const [
          DashboardScreen(),
          TransactionScreen(embedded: true),
          BudgetScreen(embedded: true),
          SettingsScreen(),
        ],
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () {
                showAddTransactionSheet(context, ref);
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomIndexForTab(_tab),
        onTap: (i) {
          if (i == 2) {
            showAddTransactionSheet(context, ref);
            return;
          }
          setState(() => _tab = _tabForBottomIndex(i));
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: AppStrings.navDashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined),
            label: AppStrings.navTransactions,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_circle_outline),
            label: AppStrings.navAddTransaction,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.pie_chart_outline),
            label: AppStrings.navBudget,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.more_horiz),
            label: AppStrings.navMore,
          ),
        ],
      ),
    );
  }
}
