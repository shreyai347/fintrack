import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/config/theme_mode_notifier.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';

import '../../transactions/model/category_model.dart';
import '../../transactions/model/transaction_model.dart';
import '../../transactions/repository/category_repository_impl.dart';
import '../../budget/viewmodel/budget_provider.dart';
import '../model/chart_data_model.dart';
import '../repository/dashboard_repository_impl.dart';
import 'dashboard_state.dart';

class DashboardNotifier extends Notifier<DashboardState> {
  StreamSubscription<List<TransactionModel>>? _sub;

  bool _isDark() {
    final m = ref.read(themeModeNotifierProvider);
    if (m == ThemeMode.dark) return true;
    if (m == ThemeMode.light) return false;
    final platform = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return platform == Brightness.dark;
  }

  @override
  DashboardState build() {
    final repo = ref.read(dashboardRepositoryProvider);
    ref.onDispose(() => _sub?.cancel());
    _sub?.cancel();
    _sub = repo.watchRecentTransactions(5).listen(_onRecent);
    scheduleMicrotask(() => _fetch(showLoading: true));
    return const DashboardLoading();
  }

  void _onRecent(List<TransactionModel> recent) {
    final s = state;
    if (s is! DashboardLoaded) return;
    state = DashboardLoaded(
      s.summary.copyWith(recentTransactions: recent),
      s.segments,
      s.weeklyData,
    );
  }

  Future<void> _fetch({required bool showLoading}) async {
    if (showLoading) {
      state = const DashboardLoading();
    }
    try {
      final repo = ref.read(dashboardRepositoryProvider);
      final now = DateTime.now();
      final from = DateTime(now.year, now.month, 1);
      final summary = await repo.getSummary(from, now);
      final weekly = await repo.getWeeklyBreakdown(now);
      final cats = await ref.read(categoryRepositoryProvider).getAll();
      final segments =
          _buildSegments(summary.spentByCategory, cats, _isDark());
      state = DashboardLoaded(summary, segments, weekly);
    } catch (e) {
      state = DashboardError('$e');
    }
  }

  List<DonutSegment> _buildSegments(
    Map<int, double> spentByCategory,
    List<CategoryModel> categories,
    bool dark,
  ) {
    if (spentByCategory.isEmpty) return [];

    Color pickColor(int index) {
      switch (index) {
        case 0:
          return dark ? AppColors.accentDark : AppColors.accentLight;
        case 1:
          return dark ? AppColors.income : AppColors.incomeLight;
        case 2:
          return AppColors.donutSegmentBlue;
        default:
          return dark ? AppColors.expense : AppColors.expenseLight;
      }
    }

    String nameFor(int id) {
      for (final c in categories) {
        if (c.id == id) return c.name;
      }
      return '—';
    }

    final entries = spentByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = entries.take(4).toList();
    var others = 0.0;
    for (var i = 4; i < entries.length; i++) {
      others += entries[i].value;
    }

    final rows = <({int id, String label, double amount, Color color})>[];
    for (var i = 0; i < top.length; i++) {
      final e = top[i];
      rows.add((
        id: e.key,
        label: nameFor(e.key),
        amount: e.value,
        color: pickColor(i),
      ));
    }
    if (others > 0) {
      rows.add((
        id: -1,
        label: AppStrings.chartOthers,
        amount: others,
        color: dark ? AppColors.textMutedDark : AppColors.textMutedLight,
      ));
    }

    final totalAmt = rows.fold<double>(0, (a, b) => a + b.amount);
    if (totalAmt <= 0) return [];

    return [
      for (final r in rows)
        DonutSegment(
          label: r.label,
          amount: r.amount,
          percentage: r.amount / totalAmt * 100,
          color: r.color,
          categoryId: r.id,
        ),
    ];
  }

  Future<void> refresh() async {
    await _fetch(showLoading: false);
    await ref.read(budgetNotifierProvider.notifier).refresh();
  }
}
