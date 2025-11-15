import '../entities/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';

/// Use case - Encapsulates business logic for getting dashboard summary
class GetDashboardSummaryUseCase {
  final DashboardRepository repository;

  GetDashboardSummaryUseCase(this.repository);

  Future<DashboardSummary> call(String farmId) async {
    if (farmId.trim().isEmpty) {
      throw ArgumentError('Farm ID cannot be empty');
    }

    return repository.getDashboardSummary(farmId.trim());
  }
}
