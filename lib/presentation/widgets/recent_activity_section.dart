import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/sale_providers.dart';
import '../../application/providers/expense_providers.dart';
import '../../application/providers/production_record_providers.dart';
import '../../domain/entities/sale.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/production_record.dart';

/// Recent Activity Item Model
class RecentActivityItem {
  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final IconData icon;
  final Color iconColor;
  final String route;
  final String type; // 'sale', 'expense', 'production'

  RecentActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.iconColor,
    required this.route,
    required this.type,
  });
}

/// Presentation Widget - Recent Activity Section
class RecentActivitySection extends ConsumerWidget {
  final Function(String)? onNavigate;

  const RecentActivitySection({super.key, this.onNavigate});

  List<RecentActivityItem> _combineActivities(
    List<Sale> sales,
    List<Expense> expenses,
    List<ProductionRecord> productionRecords,
  ) {
    final List<RecentActivityItem> activities = [];

    // Add sales
    for (var sale in sales) {
      activities.add(RecentActivityItem(
        id: 'sale_${sale.saleId}',
        title: 'Sale Recorded',
        subtitle: '${sale.product} - GH₵${sale.totalAmount.toStringAsFixed(2)}',
        date: sale.saleDate,
        icon: Icons.shopping_cart,
        iconColor: Colors.green,
        route: '/sales',
        type: 'sale',
      ));
    }

    // Add expenses
    for (var expense in expenses) {
      activities.add(RecentActivityItem(
        id: 'expense_${expense.expenseId}',
        title: 'Expense Recorded',
        subtitle: '${expense.category} - GH₵${expense.amount.toStringAsFixed(2)}',
        date: expense.expenseDate,
        icon: Icons.payment,
        iconColor: Colors.red,
        route: '/expenses',
        type: 'expense',
      ));
    }

    // Add production records
    for (var record in productionRecords) {
      activities.add(RecentActivityItem(
        id: 'production_${record.id}',
        title: 'Production Recorded',
        subtitle: 'Total: ${record.totalProduction} eggs',
        date: record.date,
        icon: Icons.egg,
        iconColor: Colors.orange,
        route: '/production-records',
        type: 'production',
      ));
    }

    // Sort by date (most recent first)
    activities.sort((a, b) => b.date.compareTo(a.date));

    // Return only the 5 most recent
    return activities.take(5).toList();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saleState = ref.watch(saleControllerProvider);
    final expenseState = ref.watch(expenseControllerProvider);
    final productionState = ref.watch(productionRecordControllerProvider);

    final isLoading =
        saleState.isLoading || expenseState.isLoading || productionState.isLoading;

    List<RecentActivityItem> activities = [];
    if (!isLoading) {
      activities = _combineActivities(
        saleState.sales,
        expenseState.expenses,
        productionState.productionRecords,
      );
    }

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Content
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (activities.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No recent activity to display',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return InkWell(
                    onTap: onNavigate != null
                        ? () => onNavigate!(activity.route)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: activity.iconColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              activity.icon,
                              color: activity.iconColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activity.subtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Date
                          Text(
                            _formatDate(activity.date),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
