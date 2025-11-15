import '../../domain/entities/dashboard_summary.dart';

/// Data model - Maps between domain entity and API response
class DashboardSummaryModel {
  final int? totalCustomers;
  final int? totalProduction;
  final int totalEggsToday;
  final int activeFlocks;
  final double? totalSales;
  final double? thisMonthSales;
  final double? averageSale;
  final double? productionEfficiency;
  final int? salesTransactions;
  final double feedUsedTodayKg;
  final double salesToday;
  final double expensesToday;
  final List<ChartPointModel> eggChart;
  final List<ChartPointModel> feedChart;
  final List<ChartPointModel> salesChart;
  final List<ChartPointModel> expensesChart;

  DashboardSummaryModel({
    this.totalCustomers,
    this.totalProduction,
    this.totalEggsToday = 0,
    this.activeFlocks = 0,
    this.totalSales,
    this.thisMonthSales,
    this.averageSale,
    this.productionEfficiency,
    this.salesTransactions,
    this.feedUsedTodayKg = 0.0,
    this.salesToday = 0.0,
    this.expensesToday = 0.0,
    this.eggChart = const [],
    this.feedChart = const [],
    this.salesChart = const [],
    this.expensesChart = const [],
  });

  /// Convert from JSON (API response)
  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalEggsToday: json['totalEggsToday'] as int? ?? 0,
      activeFlocks: json['activeFlocks'] as int? ?? 0,
      feedUsedTodayKg: (json['feedUsedTodayKg'] as num?)?.toDouble() ?? 0.0,
      salesToday: (json['salesToday'] as num?)?.toDouble() ?? 0.0,
      expensesToday: (json['expensesToday'] as num?)?.toDouble() ?? 0.0,
      eggChart:
          (json['eggChart'] as List<dynamic>?)
              ?.map((e) => ChartPointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      feedChart:
          (json['feedChart'] as List<dynamic>?)
              ?.map((e) => ChartPointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      salesChart:
          (json['salesChart'] as List<dynamic>?)
              ?.map((e) => ChartPointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      expensesChart:
          (json['expensesChart'] as List<dynamic>?)
              ?.map((e) => ChartPointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert to domain entity
  DashboardSummary toEntity() {
    // Calculate derived values if not provided
    final totalSalesValue = totalSales ?? salesToday;
    final totalEggs = totalProduction ?? totalEggsToday;

    // Calculate average sale if we have sales and transactions
    final avgSale =
        averageSale ??
        (salesTransactions != null && salesTransactions! > 0
            ? totalSalesValue / salesTransactions!
            : 0.0);

    return DashboardSummary(
      totalCustomers: totalCustomers ?? 1, // Default from web UI
      totalProduction: totalProduction ?? totalEggsToday,
      totalEggs: totalEggs,
      activeFlocks: activeFlocks,
      totalSales: totalSalesValue,
      thisMonthSales: thisMonthSales ?? salesToday,
      averageSale: avgSale,
      productionEfficiency: productionEfficiency ?? 0.0,
      salesTransactions: salesTransactions ?? 2, // Default from web UI
      totalEggsToday: totalEggsToday,
      feedUsedTodayKg: feedUsedTodayKg,
      salesToday: salesToday,
      expensesToday: expensesToday,
    );
  }
}

class ChartPointModel {
  final String label;
  final double value;

  ChartPointModel({required this.label, required this.value});

  factory ChartPointModel.fromJson(Map<String, dynamic> json) {
    return ChartPointModel(
      label: json['label'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ChartPoint toEntity() {
    return ChartPoint(label: label, value: value);
  }
}
