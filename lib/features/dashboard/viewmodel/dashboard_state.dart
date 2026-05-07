import '../model/chart_data_model.dart';
import '../model/dashboard_summary_model.dart';

sealed class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded(this.summary, this.segments, this.weeklyData);

  final DashboardSummary summary;
  final List<DonutSegment> segments;
  final List<WeeklyBarData> weeklyData;
}

class DashboardError extends DashboardState {
  const DashboardError(this.message);
  final String message;
}
