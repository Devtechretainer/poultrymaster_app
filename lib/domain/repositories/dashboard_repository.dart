import '../entities/dashboard_summary.dart';

/// Repository interface - Defines contract for dashboard data operations
abstract class DashboardRepository {
  /// Get dashboard summary data
  Future<DashboardSummary> getDashboardSummary(String farmId);
}
