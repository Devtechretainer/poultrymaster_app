import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../states/dashboard_state.dart';

/// Controller - Manages dashboard state and coordinates use cases
class DashboardController extends StateNotifier<DashboardState> {
  final GetDashboardSummaryUseCase getDashboardSummaryUseCase;
  final String farmId;

  DashboardController({
    required this.getDashboardSummaryUseCase,
    required this.farmId,
  }) : super(const DashboardState()) {
    loadDashboard();
  }

  /// Load dashboard data
  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final summary = await getDashboardSummaryUseCase(farmId);
      final cards = _generateSummaryCards(summary);

      state = state.copyWith(summary: summary, cards: cards, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Generate summary cards from dashboard summary
  List<SummaryCard> _generateSummaryCards(DashboardSummary summary) {
    return [
      SummaryCard(
        title: 'TOTAL CUSTOMERS',
        value: '${summary.totalCustomers}',
        trend: '↑ 12% Since last month',
        isPositiveTrend: true,
        icon: Icons.people,
        iconColor: Colors.blue,
      ),
      SummaryCard(
        title: 'TOTAL PRODUCTION',
        value: '${summary.totalProduction}',
        trend: '↑ 8% Since last month',
        isPositiveTrend: true,
        icon: Icons.trending_up,
        iconColor: Colors.green,
      ),
      SummaryCard(
        title: 'TOTAL EGGS',
        value: '${summary.totalEggs}',
        trend: '↑ 15% Since last month',
        isPositiveTrend: true,
        icon: Icons.circle,
        iconColor: Colors.orange,
      ),
      SummaryCard(
        title: 'ACTIVE FLOCKS',
        value: '${summary.activeFlocks}',
        trend: '↑ ${summary.activeFlocks} Since last month',
        isPositiveTrend: true,
        icon: Icons.pets,
        iconColor: Colors.purple,
      ),
      SummaryCard(
        title: 'TOTAL SALES',
        value: 'GH₵${summary.totalSales.toStringAsFixed(2)}',
        trend: '${summary.salesTransactions} transactions',
        isPositiveTrend: true,
        icon: Icons.attach_money,
        iconColor: Colors.green,
      ),
      SummaryCard(
        title: 'THIS MONTH SALES',
        value: 'GH₵${summary.thisMonthSales.toStringAsFixed(2)}',
        trend: '↑ 18% Since last month',
        isPositiveTrend: true,
        icon: Icons.bar_chart,
        iconColor: Colors.blue,
      ),
      SummaryCard(
        title: 'AVERAGE SALE',
        value: 'GH₵${summary.averageSale.toStringAsFixed(2)}',
        trend: '↑ 5% Since last month',
        isPositiveTrend: true,
        icon: Icons.account_balance_wallet,
        iconColor: Colors.purple,
      ),
      SummaryCard(
        title: 'PRODUCTION EFFICIENCY',
        value: '${summary.productionEfficiency.toStringAsFixed(1)}%',
        trend: '↑ 2.1% Since last month',
        isPositiveTrend: true,
        icon: Icons.check_circle,
        iconColor: Colors.blue,
      ),
    ];
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}
