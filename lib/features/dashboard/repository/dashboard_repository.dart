import '../../transactions/model/transaction_model.dart';
import '../model/chart_data_model.dart';
import '../model/dashboard_summary_model.dart';

abstract class DashboardRepository {
  Future<DashboardSummary> getSummary(DateTime from, DateTime to);

  Stream<List<TransactionModel>> watchRecentTransactions(int limit);

  Future<double> getPreviousMonthSpent();

  Future<List<WeeklyBarData>> getWeeklyBreakdown(DateTime month);
}
