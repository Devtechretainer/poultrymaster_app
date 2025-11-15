import 'package:flutter/material.dart';
import '../../application/states/dashboard_state.dart';

/// Presentation Widget - Summary Card
/// Displays a single metric card with value, trend, and icon
class SummaryCardWidget extends StatelessWidget {
  final SummaryCard card;

  const SummaryCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              card.title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            // Value and Icon Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Value
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (card.trend != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              card.isPositiveTrend
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 14,
                              color: card.isPositiveTrend
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              card.trend!,
                              style: TextStyle(
                                fontSize: 12,
                                color: card.isPositiveTrend
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: card.iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(card.icon, color: card.iconColor, size: 28),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
