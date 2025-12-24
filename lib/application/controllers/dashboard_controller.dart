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
        trend: null,
        isPositiveTrend: true,
        icon: Icons.people,
        iconColor: Colors.blue,
        route: '/customers',
      ),
      SummaryCard(
        title: 'TOTAL PRODUCTION',
        value: '${summary.totalProduction}',
        trend: null,
        isPositiveTrend: true,
        icon: Icons.trending_up,
        iconColor: Colors.green,
        route: '/production-records',
      ),
      SummaryCard(
        title: 'TOTAL EGGS',
        value: '${summary.totalEggs}',
        trend: null,
        isPositiveTrend: true,
        icon: Icons.circle,
        iconColor: Colors.orange,
        route: '/egg-production',
      ),
      SummaryCard(
        title: 'ACTIVE FLOCKS',
        value: '${summary.activeFlocks}',
        trend: null,
        isPositiveTrend: true,
        icon: Icons.pets,
        iconColor: Colors.purple,
        route: '/flocks',
      ),
      SummaryCard(
        title: 'TOTAL SALES',
        value: 'GH₵${summary.totalSales.toStringAsFixed(2)}',
        trend: null,
        isPositiveTrend: true,
        icon: Icons.attach_money,
        iconColor: Colors.green,
        route: '/sales',
      ),
      SummaryCard(
        title: 'THIS MONTH SALES',
        value: 'GH₵${summary.thisMonthSales.toStringAsFixed(2)}',
        trend: null,
        isPositiveTrend: true,
        icon: Icons.bar_chart,
        iconColor: Colors.blue,
        route: '/sales',
      ),
      SummaryCard(
        title: 'AVERAGE SALE',
        value: 'GH₵${summary.averageSale.toStringAsFixed(2)}',
        trend: null,
        isPositiveTrend: true,
        icon: Icons.account_balance_wallet,
        iconColor: Colors.purple,
        route: '/sales',
      ),
      SummaryCard(
        title: 'PRODUCTION EFFICIENCY',
        value: '${summary.productionEfficiency.toStringAsFixed(1)}%',
        trend: null,
        isPositiveTrend: true,
        icon: Icons.check_circle,
        iconColor: Colors.blue,
        route: '/production-records',
      ),
    ];
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}
