import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/core/constants/app_strings.dart';
import 'package:fintrack/core/utils/date_formatter.dart';

import '../model/transaction_model.dart';
import '../../dashboard/viewmodel/dashboard_provider.dart';
import '../viewmodel/transaction_provider.dart';
import '../viewmodel/transaction_state.dart';
import 'add_transaction_screen.dart';
import 'widgets/empty_transaction_widget.dart';
import 'widgets/transaction_card.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionNotifierProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColors.scaffoldDark : AppColors.scaffoldLight;

    final body = RefreshIndicator(
      onRefresh: () async {
        await ref.read(dashboardNotifierProvider.notifier).refresh();
      },
      child: Builder(
        builder: (context) {
          if (state is TransactionLoading || state is TransactionInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TransactionError) {
            final err = state;
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 120),
                Center(
                  child: Column(
                    children: [
                      Text(err.message),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () {
                          ref
                              .read(transactionNotifierProvider.notifier)
                              .retry();
                        },
                        child: Text(AppStrings.transactionsRetry),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          final loaded = state as TransactionLoaded;
          if (loaded.transactions.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                EmptyTransactionWidget(),
              ],
            );
          }
          return categoriesAsync.when(
            data: (cats) {
              final map = {for (final c in cats) c.id: c};
              final grouped = _groupByDay(loaded.transactions);
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: grouped.length,
                itemBuilder: (context, i) {
                  final entry = grouped[i];
                  final day = entry.key;
                  final txs = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 4),
                        child: Text(
                          DateFormatter.formatGroupHeader(day),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.accentDark
                                    : AppColors.accentLight,
                              ),
                        ),
                      ),
                      ...txs.map((tx) {
                        final cat = map[tx.categoryId];
                        if (cat == null) return const SizedBox.shrink();
                        return TransactionCard(
                          transaction: tx,
                          category: cat,
                        );
                      }),
                    ],
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
          );
        },
      ),
    );

    if (embedded) {
      return ColoredBox(color: bg, child: SafeArea(child: body));
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(AppStrings.navTransactions),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTransactionSheet(context, ref);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(child: body),
    );
  }
}

List<MapEntry<DateTime, List<TransactionModel>>> _groupByDay(
    List<TransactionModel> list) {
  final map = <DateTime, List<TransactionModel>>{};
  for (final t in list) {
    final d = DateTime(t.date.year, t.date.month, t.date.day);
    map.putIfAbsent(d, () => []).add(t);
  }
  final keys = map.keys.toList()..sort((a, b) => b.compareTo(a));
  return [for (final k in keys) MapEntry(k, map[k]!)];
}
