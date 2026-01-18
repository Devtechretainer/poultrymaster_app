import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../application/states/dashboard_state.dart';

/// Presentation Widget - Summary Card
/// Displays a single metric card with value, trend, and icon
/// Fully responsive design that prevents overflow using ScreenUtil
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: LayoutBuilder(
          builder: (context, constraints) {
          // Cache constraint values to avoid repeated calculations
          final maxWidth = constraints.maxWidth;
          // Responsive sizing based on available width and mobile flag
          final isSmall = maxWidth < 150.w;
          final isVerySmall = maxWidth < 120.w;

          // Enhanced padding and sizing for mobile to ensure percentages are visible
          final padding = isMobile
              ? (isVerySmall ? 10.w : 12.w)
              : (isVerySmall ? 8.w : (isSmall ? 10.w : 12.w));

          final valueFontSize = isMobile
              ? (isSmall ? 20.sp : 24.sp)
              : (isSmall ? 18.sp : 22.sp);

          final iconSize = isMobile
              ? (isVerySmall ? 32.w : (isSmall ? 36.w : 44.w))
              : (isVerySmall ? 28.w : (isSmall ? 32.w : 40.w));

          final iconInnerSize = isMobile
              ? (isVerySmall ? 18.sp : (isSmall ? 20.sp : 26.sp))
              : (isVerySmall ? 16.sp : (isSmall ? 18.sp : 24.sp));

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
            mainAxisSize: MainAxisSize.min, // Use min to prevent overflow
            children: [
              // Title
              Text(
                card.title,
                style: TextStyle(
                  fontSize: isMobile
                      ? (isSmall ? 11.sp : 13.sp)
                      : (isSmall ? 11.sp : 12.sp),
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(height: isMobile ? 8.h : (isVerySmall ? 4.h : 8.h)), // Reduced spacing
              // Value
              Text(
                card.value,
                style: TextStyle(
                  fontSize: isMobile ? (isSmall ? 22.sp : 28.sp) : valueFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              // Trend - Enhanced for mobile to ensure percentages are fully visible
              if (card.trend != null) ...[
                SizedBox(height: isMobile ? 6.h : (isVerySmall ? 2.h : 4.h)), // Reduced spacing
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      card.isPositiveTrend
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: isMobile
                          ? (isVerySmall ? 16.sp : 18.sp)
                          : (isVerySmall ? 14.sp : 16.sp),
                      color: trendColor,
                    ),
                    SizedBox(width: isMobile ? 4.w : 3.w), // Reduced spacing
                    // Allow percentage text to wrap on mobile
                    Flexible(
                      child: Text(
                        card.trend!,
                        style: TextStyle(
                          fontSize: isMobile
                              ? (isVerySmall ? 12.sp : 14.sp)
                              : (isVerySmall ? 11.sp : 12.sp),
                          color: trendColor,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2, // Allow 2 lines to show full percentage text
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        // Right side: Circular icon background (matching POC design)
        SizedBox(width: 8.w), // Reduced spacing
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
