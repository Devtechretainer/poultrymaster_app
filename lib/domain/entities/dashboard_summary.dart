/// Domain entity - Dashboard summary data
/// Pure business data model, no Flutter/API dependencies
class DashboardSummary {
  final int totalCustomers;
  final int totalProduction;
  final int totalEggs;
  final int activeFlocks;
  final double totalSales;
  final double thisMonthSales;
  final double averageSale;
  final double productionEfficiency;
  final int salesTransactions;
  final int totalEggsToday;
  final double feedUsedTodayKg;
  final double salesToday;
  final double expensesToday;

  const DashboardSummary({
    required this.totalCustomers,
    required this.totalProduction,
    required this.totalEggs,
    required this.activeFlocks,
    required this.totalSales,
    required this.thisMonthSales,
    required this.averageSale,
    required this.productionEfficiency,
    this.salesTransactions = 0,
    this.totalEggsToday = 0,
    this.feedUsedTodayKg = 0.0,
    this.salesToday = 0.0,
    this.expensesToday = 0.0,
  });
}

/// Chart point for graphs
class ChartPoint {
  final String label;
  final double value;

  const ChartPoint({required this.label, required this.value});
}
