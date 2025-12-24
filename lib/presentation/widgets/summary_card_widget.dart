import 'package:flutter/material.dart';
import '../../application/states/dashboard_state.dart';

/// Presentation Widget - Summary Card
/// Displays a single metric card with value, trend, and icon
/// Fully responsive design that prevents overflow
class SummaryCardWidget extends StatelessWidget {
  final SummaryCard card;
  final bool isMobile;
  final VoidCallback? onTap;

  const SummaryCardWidget({
    super.key,
    required this.card,
    this.isMobile = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
          // Cache constraint values to avoid repeated calculations
          final maxWidth = constraints.maxWidth;
          // Responsive sizing based on available width and mobile flag
          final isSmall = maxWidth < 150;
          final isVerySmall = maxWidth < 120;

          // Enhanced padding and sizing for mobile to ensure percentages are visible
          final padding = isMobile
              ? (isVerySmall ? 10.0 : 12.0)
              : (isVerySmall ? 8.0 : (isSmall ? 10.0 : 12.0));

          final valueFontSize = isMobile
              ? (isSmall ? 20.0 : 24.0)
              : (isSmall ? 18.0 : 22.0);

          final iconSize = isMobile
              ? (isVerySmall ? 32.0 : (isSmall ? 36.0 : 44.0))
              : (isVerySmall ? 28.0 : (isSmall ? 32.0 : 40.0));

          final iconInnerSize = isMobile
              ? (isVerySmall ? 18.0 : (isSmall ? 20.0 : 26.0))
              : (isVerySmall ? 16.0 : (isSmall ? 18.0 : 24.0));

          return Padding(
            padding: EdgeInsets.all(padding),
            child: _buildCardContent(
              isSmall,
              isVerySmall,
              valueFontSize,
              iconSize,
              iconInnerSize,
            ),
          );
          },
        ),
      ),
    );
  }

  Widget _buildCardContent(
    bool isSmall,
    bool isVerySmall,
    double valueFontSize,
    double iconSize,
    double iconInnerSize,
  ) {
    final trendColor = card.isPositiveTrend
        ? Colors.green[600]!
        : Colors.red[600]!;

    // Match POC design: Row layout with content on left, circular icon on right
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side: Content (title, value, trend)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                card.title,
                style: TextStyle(
                  fontSize: isMobile
                      ? (isSmall ? 11 : 13)
                      : (isSmall ? 11 : 12),
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(height: isMobile ? 12 : (isVerySmall ? 8 : 12)),
              // Value
              Text(
                card.value,
                style: TextStyle(
                  fontSize: isMobile ? (isSmall ? 22 : 28) : valueFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              // Trend - Enhanced for mobile to ensure percentages are fully visible
              if (card.trend != null) ...[
                SizedBox(height: isMobile ? 8 : (isVerySmall ? 4 : 6)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      card.isPositiveTrend
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: isMobile
                          ? (isVerySmall ? 16 : 18)
                          : (isVerySmall ? 14 : 16),
                      color: trendColor,
                    ),
                    SizedBox(width: isMobile ? 6 : 4),
                    // Allow percentage text to wrap on mobile
                    Flexible(
                      child: Text(
                        card.trend!,
                        style: TextStyle(
                          fontSize: isMobile
                              ? (isVerySmall ? 12 : 14)
                              : (isVerySmall ? 11 : 12),
                          color: trendColor,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines:
                            2, // Allow 2 lines to show full percentage text
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        // Right side: Circular icon background (matching POC design)
        SizedBox(width: 12),
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: card.iconColor, // Solid color, not opacity (matches POC)
            shape: BoxShape.circle, // Circular, not rounded rectangle
          ),
          child: Icon(
            card.icon,
            color: Colors.white, // White icon on colored background
            size: iconInnerSize,
          ),
        ),
      ],
    );
  }
}
