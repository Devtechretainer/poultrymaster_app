import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_summary.dart';

/// Summary card data for UI
class SummaryCard {
  final String title;
  final String value;
  final String? trend;
  final bool isPositiveTrend;
  final IconData icon;
  final Color iconColor;

  const SummaryCard({
    required this.title,
    required this.value,
    this.trend,
    this.isPositiveTrend = true,
    required this.icon,
    required this.iconColor,
  });
}

/// Application state - Represents dashboard UI state
class DashboardState {
  final DashboardSummary? summary;
  final List<SummaryCard> cards;
  final bool isLoading;
  final String? error;

  const DashboardState({
    this.summary,
    this.cards = const [],
    this.isLoading = false,
    this.error,
  });

  /// Creates a copy with updated values
  DashboardState copyWith({
    DashboardSummary? summary,
    List<SummaryCard>? cards,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      summary: summary ?? this.summary,
      cards: cards ?? this.cards,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
