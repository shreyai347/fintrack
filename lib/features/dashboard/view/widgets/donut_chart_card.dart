import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/core/config/app_routes.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/utils/date_formatter.dart';
import 'package:fintrack/core/widgets/animated_card.dart';
import 'package:fintrack/core/widgets/category_icon.dart';

import '../../../transactions/model/category_model.dart';
import '../../../transactions/model/transaction_model.dart';
import '../../../transactions/viewmodel/transaction_provider.dart';
import '../../../transactions/viewmodel/transaction_state.dart';
import '../../model/chart_data_model.dart';
import '../painter/donut_chart_painter.dart';

class DonutChartCard extends ConsumerStatefulWidget {
  const DonutChartCard({super.key, required this.segments});

  final List<DonutSegment> segments;

  @override
  ConsumerState<DonutChartCard> createState() => _DonutChartCardState();
}

class _DonutChartCardState extends ConsumerState<DonutChartCard> {
  int? _selectedIndex;

  static const Size _chartSize = Size(130, 130);

  @override
  void didUpdateWidget(covariant DonutChartCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldS = oldWidget.segments;
    final newS = widget.segments;
    if (oldS.length != newS.length) {
      _selectedIndex = null;
      return;
    }
    for (var i = 0; i < newS.length; i++) {
      if (oldS[i].categoryId != newS[i].categoryId ||
          oldS[i].amount != newS[i].amount) {
        _selectedIndex = null;
        return;
      }
    }
  }

  List<TransactionModel> _monthExpensesForCategory(
    List<TransactionModel> all,
    int categoryId,
  ) {
    final n = DateTime.now();
    return all
        .where((t) =>
            t.categoryId == categoryId &&
            t.amount < 0 &&
            t.date.year == n.year &&
            t.date.month == n.month)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  CategoryModel? _categoryById(List<CategoryModel>? cats, int id) {
    if (cats == null) return null;
    for (final c in cats) {
      if (c.id == id) return c;
    }
    return null;
  }

  void _openDetail(BuildContext context, int transactionId) {
    Navigator.of(context).pushNamed(
      AppRoutes.transactionDetail,
      arguments: transactionId,
    );
  }

  void _openTransactionsTab(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.transactions);
  }

  Widget _sidePanel({
    required BuildContext context,
    required DonutSegment segment,
    required List<TransactionModel> txs,
    required CategoryModel? category,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final input = dark ? AppColors.inputDark : AppColors.inputLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final bold = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final amountColor = dark ? AppColors.expense : AppColors.expenseLight;

    final preview = txs.take(5).toList();

    Widget body;
    if (segment.categoryId < 0) {
      body = Text(
        l10n.donutOthersDetail,
        style: TextStyle(color: muted, fontSize: 12, height: 1.35),
      );
    } else if (txs.isEmpty) {
      body = Text(
        l10n.transactionsEmptyTitle,
        style: TextStyle(color: muted, fontSize: 12),
      );
    } else {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final t in preview)
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _openDetail(context, t.id),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                  child: Row(
                    children: [
                      if (category != null)
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: category.color,
                          child: CategoryIcon(
                            category: category,
                            size: 16,
                            iconColor: AppColors.onVivid,
                          ),
                        )
                      else
                        const SizedBox(width: 28),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (t.note?.trim().isNotEmpty ?? false)
                                  ? t.note!.trim()
                                  : l10n.transactionsListFallbackTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: bold,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              DateFormatter.formatShort(t.date),
                              style: TextStyle(color: muted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(t.amount.abs()),
                        style: TextStyle(
                          color: amountColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (txs.length > preview.length)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l10n.donutMoreCount(txs.length - preview.length),
                style: TextStyle(color: muted, fontSize: 11),
              ),
            ),
        ],
      );
    }

    return AnimatedCard(
      key: ValueKey<int>(segment.categoryId),
      duration: const Duration(milliseconds: 380),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        decoration: BoxDecoration(
          color: input,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              segment.label,
              style: TextStyle(
                color: bold,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              l10n.donutCategoryExpenses,
              style: TextStyle(color: muted, fontSize: 11),
            ),
            if (segment.categoryId >= 0 && txs.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                l10n.donutOpenDetail,
                style: TextStyle(color: muted, fontSize: 10),
              ),
            ],
            const SizedBox(height: 8),
            body,
            TextButton.icon(
              onPressed: () => _openTransactionsTab(context),
              icon: Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: dark ? AppColors.accentDark : AppColors.accentLight,
              ),
              label: Text(l10n.donutSeeAllTransactions),
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                foregroundColor:
                    dark ? AppColors.accentDark : AppColors.accentLight,
                padding: const EdgeInsets.symmetric(vertical: 4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final track = dark ? AppColors.inputDark : AppColors.inputLight;
    final muted = dark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final bold = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final border = dark ? AppColors.borderDark : AppColors.borderLight;
    final card = dark ? AppColors.cardDark : AppColors.cardLight;

    final segments = widget.segments;
    final sel = _selectedIndex;

    final txState = ref.watch(transactionNotifierProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.asData?.value;

    String centerTop;
    String centerBottom;
    if (segments.isEmpty) {
      centerTop = '';
      centerBottom = '—';
    } else if (sel != null && sel < segments.length) {
      final s = segments[sel];
      centerTop = s.label;
      centerBottom = CurrencyFormatter.format(s.amount);
    } else {
      centerTop = l10n.donutTopLabel;
      centerBottom = segments.first.label;
    }

    final activeSeg =
        sel != null && sel < segments.length ? segments[sel] : null;
    final showSide = activeSeg != null;

    final List<TransactionModel> sideTxs = txState is TransactionLoaded &&
            activeSeg != null &&
            activeSeg.categoryId >= 0
        ? _monthExpensesForCategory(
            txState.transactions,
            activeSeg.categoryId,
          )
        : <TransactionModel>[];

    final CategoryModel? sideCat =
        activeSeg != null && activeSeg.categoryId >= 0
            ? _categoryById(categories, activeSeg.categoryId)
            : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: _chartSize.height,
                    width: _chartSize.width,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (d) {
                        final idx = DonutChartPainter.segmentAt(
                          d.localPosition,
                          _chartSize,
                          segments,
                        );
                        setState(() => _selectedIndex = idx);
                      },
                      child: CustomPaint(
                        size: _chartSize,
                        painter: DonutChartPainter(
                          segments: segments,
                          centerTop: centerTop,
                          centerBottom: centerBottom,
                          trackColor: track,
                          mutedColor: muted,
                          boldColor: bold,
                          selectedIndex: sel,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (showSide) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: txState is TransactionLoading
                      ? SizedBox(
                          height: 100,
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: dark
                                    ? AppColors.accentDark
                                    : AppColors.accentLight,
                              ),
                            ),
                          ),
                        )
                      : txState is TransactionError
                          ? Text(
                              txState.message,
                              style: TextStyle(color: muted, fontSize: 12),
                            )
                          : _sidePanel(
                              context: context,
                              segment: activeSeg,
                              txs: sideTxs,
                              category: sideCat,
                            ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.donutTapHint,
            style: TextStyle(color: muted, fontSize: 11),
          ),
          const SizedBox(height: 8),
          ...segments.asMap().entries.map((e) {
            final i = e.key;
            final s = e.value;
            final selected = sel == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () =>
                      setState(() => _selectedIndex = selected ? null : i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: s.color,
                            shape: BoxShape.circle,
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: s.color.withValues(alpha: 0.5),
                                      blurRadius: 6,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            s.label,
                            style: TextStyle(
                              color: bold,
                              fontSize: 13,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          '${s.percentage.toStringAsFixed(0)}%',
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          CurrencyFormatter.format(s.amount),
                          style: TextStyle(
                            color: bold,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
