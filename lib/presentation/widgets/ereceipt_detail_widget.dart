import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// E-Receipt Style Detail Widget
/// Matches the e-receipt UI design with clean card-based layout
class EReceiptDetailWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<DetailSection> sections;
  final String? actionButtonLabel;
  final VoidCallback? onActionPressed;
  final Color? actionButtonColor;
  final Widget? headerWidget; // For barcode or custom header

  const EReceiptDetailWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.sections,
    this.actionButtonLabel,
    this.onActionPressed,
    this.actionButtonColor,
    this.headerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[900], size: 24.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Widget (Barcode or custom)
            if (headerWidget != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: headerWidget!,
              ),
            ],

            // Sections
            ...sections.map((section) => _buildSection(section)),

            // Bottom Action Button
            if (actionButtonLabel != null && onActionPressed != null) ...[
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onActionPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: actionButtonColor ?? const Color(0xFF14B8A6), // Teal-green
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      actionButtonLabel!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(DetailSection section) {
    if (section.type == DetailSectionType.itemCard) {
      return _buildItemCard(section);
    } else if (section.type == DetailSectionType.infoList) {
      return _buildInfoList(section);
    } else if (section.type == DetailSectionType.summary) {
      return _buildSummary(section);
    }
    return const SizedBox.shrink();
  }

  Widget _buildItemCard(DetailSection section) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!, width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image placeholder or icon
            if (section.imageWidget != null)
              section.imageWidget!
            else
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  section.icon ?? Icons.image,
                  color: Colors.grey[400],
                  size: 40.sp,
                ),
              ),
            SizedBox(width: 12.w),
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  if (section.subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      section.subtitle!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  if (section.footer != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      section.footer!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoList(DetailSection section) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title != null) ...[
            Text(
              section.title!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 12.h),
          ],
          ...section.items.map((item) => _buildInfoItem(item)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(DetailItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              item.label,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.value,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[900],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(DetailSection section) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title != null) ...[
            Text(
              section.title!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 12.h),
          ],
          ...section.items.map((item) => _buildSummaryItem(item)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(DetailItem item) {
    final isNegative = item.value.startsWith('-');
    final isPositive = item.value.startsWith('+');
    
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.label,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            item.value,
            style: TextStyle(
              fontSize: 13.sp,
              color: isNegative
                  ? Colors.green[700]
                  : isPositive
                      ? Colors.grey[900]
                      : Colors.grey[900],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Detail Section Model
class DetailSection {
  final DetailSectionType type;
  final String? title;
  final String? subtitle;
  final String? footer;
  final IconData? icon;
  final Widget? imageWidget;
  final List<DetailItem> items;

  const DetailSection({
    required this.type,
    this.title,
    this.subtitle,
    this.footer,
    this.icon,
    this.imageWidget,
    this.items = const [],
  });
}

/// Detail Section Type
enum DetailSectionType {
  itemCard,
  infoList,
  summary,
}

/// Detail Item Model
class DetailItem {
  final String label;
  final String value;
  final Color? valueColor;

  const DetailItem({
    required this.label,
    required this.value,
    this.valueColor,
  });
}

