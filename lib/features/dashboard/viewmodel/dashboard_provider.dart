import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../transactions/model/transaction_model.dart';
import '../repository/dashboard_repository_impl.dart';
import 'dashboard_notifier.dart';
import 'dashboard_state.dart';

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);

final recentTransactionsProvider =
    StreamProvider<List<TransactionModel>>((ref) {
  return ref.watch(dashboardRepositoryProvider).watchRecentTransactions(5);
});
