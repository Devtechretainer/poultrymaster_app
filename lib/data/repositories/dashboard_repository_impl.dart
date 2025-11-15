import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_datasource.dart';

/// Repository implementation - Coordinates data sources
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSource dataSource;
  final String farmId;
  final String? authToken;

  DashboardRepositoryImpl({
    required this.dataSource,
    required this.farmId,
    this.authToken,
  });

  @override
  Future<DashboardSummary> getDashboardSummary(String farmId) async {
    try {
      final summaryModel = await dataSource.getDashboardSummary(
        farmId,
        authToken,
      );
      return summaryModel.toEntity();
    } catch (e) {
      // For demo, return mock data if API fails
      // Remove this in production
      return const DashboardSummary(
        totalCustomers: 1,
        totalProduction: 350,
        totalEggs: 0,
        activeFlocks: 3,
        totalSales: 8400.00,
        thisMonthSales: 0.00,
        averageSale: 4200.00,
        productionEfficiency: 0.0,
        salesTransactions: 2,
      );
    }
  }
}
