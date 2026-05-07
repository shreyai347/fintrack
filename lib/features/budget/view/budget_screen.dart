import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/widgets/shimmer_skeleton.dart';
import 'package:fintrack/features/transactions/viewmodel/transaction_provider.dart';

import '../viewmodel/budget_notifier.dart';
import '../viewmodel/budget_provider.dart';
import '../viewmodel/budget_state.dart';
import 'widgets/budget_category_tile.dart';
import 'widgets/overall_budget_card.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  String _monthTitle(String monthYear) {
    final p = monthYear.split('-');
    final y = int.parse(p[0]);
    final m = int.parse(p[1]);
    return DateFormat.yMMMM('en').format(DateTime(y, m, 1));
  }

  bool _isCurrentMonth(String my) {
    final n = DateTime.now();
    final cur = BudgetNotifier.formatMonthYear(n);
    return my == cur;
  }

  String _shiftMonth(String my, int delta) {
    final p = my.split('-');
    final d = DateTime(int.parse(p[0]), int.parse(p[1]), 1);
    final t = DateTime(d.year, d.month + delta, 1);
    return BudgetNotifier.formatMonthYear(t);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetNotifierProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColors.scaffoldDark : AppColors.scaffoldLight;

    late final Widget body;
    if (state is BudgetInitial || state is BudgetLoading) {
      body = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: const [ShimmerSkeleton()],
      );
    } else if (state is BudgetError) {
      body = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.65,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: dark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          ref.read(budgetNotifierProvider.notifier).refresh(),
                      child: Text(AppStrings.dashboardRetry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else if (state is BudgetLoaded) {
      final loaded = state;
      final my = loaded.monthYear;
      final display = _monthTitle(my);
      final canNext = !_isCurrentMonth(my);
      final prevMy = _shiftMonth(my, -1);
      final nextMy = _shiftMonth(my, 1);
      final canEdit = _isCurrentMonth(my);

      body = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => ref
                    .read(budgetNotifierProvider.notifier)
                    .changeMonth(prevMy),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  display,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: dark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                onPressed: canNext
                    ? () => ref
                        .read(budgetNotifierProvider.notifier)
                        .changeMonth(nextMy)
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OverallBudgetCard(loaded: loaded),
          const SizedBox(height: 20),
          Text(
            AppStrings.byCategory,
            style: TextStyle(
              color:
                  dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          ...categoriesAsync.when(
            data: (cats) {
              final byId = {for (final c in cats) c.id: c};
              return [
                for (final b in loaded.budgets)
                  if (byId[b.categoryId] != null)
                    BudgetCategoryTile(
                      budget: b,
                      category: byId[b.categoryId]!,
                      canEdit: canEdit,
                    ),
              ];
            },
            loading: () => [const SizedBox.shrink()],
            error: (_, _) => [const SizedBox.shrink()],
          ),
        ],
      );
    } else {
      body = const SizedBox.shrink();
    }

    final scrollable = RefreshIndicator(
      onRefresh: () => ref.read(budgetNotifierProvider.notifier).refresh(),
      child: body,
    );

    if (widget.embedded) {
      return ColoredBox(color: bg, child: SafeArea(child: scrollable));
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(AppStrings.budgetScreen),
      ),
      body: SafeArea(child: scrollable),
    );
  }
}
