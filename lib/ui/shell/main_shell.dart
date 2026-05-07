import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/features/budget/view/budget_screen.dart';
import 'package:fintrack/features/dashboard/view/dashboard_screen.dart';
import 'package:fintrack/features/settings/view/settings_screen.dart';
import 'package:fintrack/features/transactions/view/add_transaction_screen.dart';
import 'package:fintrack/features/transactions/view/transaction_screen.dart';

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
    final titles = [
      AppStrings.navHome,
      AppStrings.navTxns,
      AppStrings.navBudget,
      AppStrings.navMore,
    ];

    return Scaffold(
      extendBody: true,
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
              color: const Color(0xff5B5FEF).withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            showAddTransactionSheet(context, ref);
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
              color: Colors.black.withOpacity(0.06),
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
                label: AppStrings.navHome,
                index: 0,
              ),
              _navItem(
                icon: Icons.receipt_long_rounded,
                label: AppStrings.navTxns,
                index: 1,
              ),
              const SizedBox(width: 40),
              _navItem(
                icon: Icons.pie_chart_rounded,
                label: AppStrings.navBudget,
                index: 2,
              ),
              _navItem(
                icon: Icons.more_horiz_rounded,
                label: AppStrings.navMore,
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

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() => _tab = index);
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
                  color: isSelected
                      ? _selectedColors[index]
                      : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? _selectedColors[index]
                      : Colors.grey.shade500,
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