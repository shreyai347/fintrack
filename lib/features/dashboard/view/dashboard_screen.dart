import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fintrack/core/config/user_display_name_notifier.dart';
import 'package:fintrack/core/constants/app_colors.dart';
import 'package:fintrack/l10n/app_localizations.dart';
import 'package:fintrack/core/widgets/animated_card.dart';
import 'package:fintrack/core/widgets/shimmer_skeleton.dart';

import '../../transactions/viewmodel/transaction_provider.dart';
import '../viewmodel/dashboard_provider.dart';
import '../viewmodel/dashboard_state.dart';
import 'widgets/balance_flip_card.dart';
import 'widgets/budget_alert_banner.dart';
import 'widgets/donut_chart_card.dart';
import 'widgets/recent_transactions_section.dart';
import 'widgets/spending_breakdown_card.dart';
import 'widgets/stat_row_widget.dart';
import 'widgets/weekly_bar_chart_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key, this.onProfileTap});

  final VoidCallback? onProfileTap;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(dashboardNotifierProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColors.scaffoldDark : AppColors.scaffoldLight;
    final monthLabel =
        DateFormat.yMMMM(Localizations.localeOf(context).toString())
            .format(DateTime.now());

    final Widget scrollable;
    if (state is DashboardInitial || state is DashboardLoading) {
      scrollable = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: const [ShimmerSkeleton()],
      );
    } else if (state is DashboardError) {
      final message = state.message;
      scrollable = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: dark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => ref
                          .read(dashboardNotifierProvider.notifier)
                          .refresh(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else if (state is DashboardLoaded) {
      final summary = state.summary;
      final segments = state.segments;
      final weeklyData = state.weeklyData;
      scrollable = LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderRow(
                    displayName: ref.watch(userDisplayNameNotifierProvider),
                    l10n: l10n,
                    onProfileTap: widget.onProfileTap,
                  ),
                  const SizedBox(height: 20),
                  AnimatedCard(
                    child: BalanceFlipCard(
                      summary: summary,
                      monthLabel: monthLabel,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedCard(
                    duration: const Duration(milliseconds: 380),
                    child: StatRowWidget(
                      dailyAvg: summary.dailyAverage,
                      txCount: summary.transactionCount,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedCard(
                    duration: const Duration(milliseconds: 420),
                    child: DonutChartCard(segments: segments),
                  ),
                  if (summary.isOverWarning) ...[
                    const SizedBox(height: 16),
                    BudgetAlertBanner(summary: summary),
                  ],
                  const SizedBox(height: 16),
                  AnimatedCard(
                    duration: const Duration(milliseconds: 460),
                    child: categoriesAsync.when(
                      data: (cats) => SpendingBreakdownCard(
                        summary: summary,
                        categories: cats,
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedCard(
                    duration: const Duration(milliseconds: 500),
                    child: WeeklyBarChartCard(data: weeklyData),
                  ),
                  const SizedBox(height: 16),
                  AnimatedCard(
                    duration: const Duration(milliseconds: 520),
                    child: categoriesAsync.when(
                      data: (cats) => RecentTransactionsSection(
                        transactions: summary.recentTransactions,
                        categories: cats,
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      scrollable = const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(dashboardNotifierProvider.notifier).refresh(),
          child: scrollable,
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.displayName,
    required this.l10n,
    this.onProfileTap,
  });

  final String displayName;
  final AppLocalizations l10n;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final title = dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final greeting = displayName.isEmpty
        ? l10n.dashboardHeyBuddy
        : l10n.dashboardHeyName(displayName);
    final initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : '';

    Widget avatar = CircleAvatar(
      radius: 22,
      backgroundColor: dark ? AppColors.accentDark : AppColors.accentLight,
      child: displayName.isEmpty
          ? const Icon(
              Icons.waving_hand_rounded,
              color: AppColors.onVivid,
              size: 24,
            )
          : Text(
              initial,
              style: const TextStyle(
                color: AppColors.onVivid,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
    if (onProfileTap != null) {
      avatar = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onProfileTap,
          customBorder: const CircleBorder(),
          child: avatar,
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            greeting,
            style: TextStyle(
              color: title,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
        ),
        avatar,
      ],
    );
  }
}
