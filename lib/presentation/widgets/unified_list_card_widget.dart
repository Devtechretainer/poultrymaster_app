import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Unified List Card Widget
/// Matches the Sales Baseline Form UI pattern
/// Used across all list screens (Sales, Customers, Flocks, etc.)
class UnifiedListCardWidget extends StatelessWidget {
  final String id;
  final String title;
  final List<CardField> fields;
  final String? status;
  final Color? statusColor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSend;
  final String? sendButtonLabel;
  final Color? sendButtonColor;

  const UnifiedListCardWidget({
    super.key,
    required this.id,
    required this.title,
    required this.fields,
    this.status,
    this.statusColor,
    this.onEdit,
    this.onDelete,
    this.onSend,
    this.sendButtonLabel,
    this.sendButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    final sendBgColor =
        sendButtonColor ?? const Color(0xFFE0F2FE); // Light blue

    return Card(
      elevation: 0,
      color: Colors.white, // White card background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(color: Colors.grey[300]!, width: 1.w),
      ),
      margin: EdgeInsets.zero, // End-to-end cards with no spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section with content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with title and action buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ID field
                          Text(
                            'Id : $id',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          // Title
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Action buttons in top-right
                    if (onEdit != null || onDelete != null) ...[
                      SizedBox(width: 6.w),
                      if (onEdit != null)
                        _ActionButton(
                          icon: Icons.edit,
                          color: const Color(0xFF3B82F6), // Light blue
                          onPressed: onEdit!,
                        ),
                      if (onEdit != null && onDelete != null)
                        SizedBox(width: 6.w),
                      if (onDelete != null)
                        _ActionButton(
                          icon: Icons.delete,
                          color: const Color(0xFFEF4444), // Light red
                          onPressed: onDelete!,
                        ),
                    ],
                  ],
                ),
                SizedBox(height: 10.h),
                // Fields
                ...fields.map(
                  (field) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${field.label} : ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            field.value,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[900],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Status if provided
                if (status != null) ...[
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        'Status : ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        status!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: statusColor ?? Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Bottom section with Send button (if provided)
          if (onSend != null)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: sendBgColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sendBgColor,
                      foregroundColor: const Color(0xFF2563EB), // Blue text
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        side: BorderSide(
                          color: const Color(0xFF2563EB).withOpacity(0.3),
                          width: 1.w,
                        ),
                      ),
                    ),
                    child: Text(
                      sendButtonLabel ?? 'Send',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Action Button Widget (Edit/Delete)
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6.r),
          child: Icon(icon, color: Colors.white, size: 16.sp),
        ),
      ),
    );
  }
}

/// Card Field Data Model
class CardField {
  final String label;
  final String value;

  const CardField({required this.label, required this.value});
}
