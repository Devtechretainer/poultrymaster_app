import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dashboard_sidebar.dart';
import 'dashboard_header.dart';
import 'asset_image_widget.dart';

/// Base Page Screen Template
/// Matches the frontend FarmArchive design exactly
class BasePageScreen extends StatelessWidget {
  final String currentRoute;
  final Function(String) onNavigate;
  final VoidCallback onLogout;
  final String pageTitle;
  final String pageSubtitle;
  final IconData? pageIcon;
  final String?
  pageIconAsset; // Asset path for custom icons (e.g., 'assets/icons/egg.png')
  final Color? iconBackgroundColor;
  final Widget? actionButton;
  final Widget child;
  final TextEditingController? searchController;
  final String? username;
  final String? roleLabel;
  final bool
  showSearchInHeader; // Show search in page header (for list screens)

  const BasePageScreen({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
    required this.onLogout,
    required this.pageTitle,
    required this.pageSubtitle,
    this.pageIcon,
    this.pageIconAsset,
    this.iconBackgroundColor,
    this.actionButton,
    required this.child,
    this.searchController,
    this.username,
    this.roleLabel,
    this.showSearchInHeader =
        false, // Default false, set to true for list screens
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobileScreen = constraints.maxWidth < 800;

        if (isMobileScreen) {
          // Mobile: Use drawer
          return Scaffold(
            drawer: DashboardSidebar(
              currentRoute: currentRoute,
              onNavigate: (route) {
                // Close drawer first
                Navigator.pop(context);
                // Then handle navigation after a small delay
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (context.mounted) {
                    onNavigate(route);
                  }
                });
              },
              onLogout: onLogout,
            ),
            drawerEdgeDragWidth: MediaQuery.of(
              context,
            ).size.width, // Enable swipe from edge
            body: _buildMainContent(context, isMobileScreen),
          );
        }

        // Desktop: Use permanent sidebar
        return Scaffold(
          backgroundColor: const Color(0xFFF1F5F9), // bg-slate-100
          body: Row(
            children: [
              // Sidebar Navigation
              DashboardSidebar(
                currentRoute: currentRoute,
                onNavigate: onNavigate,
                onLogout: onLogout,
              ),

              // Main Content Area
              Expanded(child: _buildMainContent(context, isMobileScreen)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, bool isMobile) {
    return Column(
      children: [
        // Header Bar
        DashboardHeader(
          searchController: showSearchInHeader
              ? null
              : searchController, // Only show search in header for dashboard
          username: username,
          roleLabel: roleLabel,
          showMenuButton: isMobile, // Show menu button on mobile
        ),

        // Main Content Area
        Expanded(
          child: Container(
            color: const Color(0xFFF1F5F9), // bg-slate-100
            padding: EdgeInsets.all(
              isMobile ? 16 : 24,
            ), // Less padding on mobile
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Header Section - Responsive layout
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmall = constraints.maxWidth < 400;

                    if (isSmall || isMobile) {
                      // Stack vertically on small screens
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      iconBackgroundColor ??
                                      const Color(0xFFF3E8FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: pageIconAsset != null
                                    ? AssetImageWidget.icon(
                                        assetPath: pageIconAsset!,
                                        size: 24,
                                        padding: const EdgeInsets.all(8.0),
                                      )
                                    : pageIcon != null
                                     ? Icon(
                                         pageIcon!,
                                         color: iconBackgroundColor != null
                                             ? Colors.white
                                             : const Color(0xFF9333EA),
                                         size: 20,
                                       )
                                     : const SizedBox.shrink(),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pageTitle,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      pageSubtitle,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF475569),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (actionButton != null) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: actionButton!,
                            ),
                          ],
                        ],
                      );
                    }

                    // Desktop: Horizontal layout
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      iconBackgroundColor ??
                                      const Color(0xFFF3E8FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: pageIconAsset != null
                                    ? AssetImageWidget.icon(
                                        assetPath: pageIconAsset!,
                                        size: 24,
                                        padding: const EdgeInsets.all(8.0),
                                      )
                                    : pageIcon != null
                                     ? Icon(
                                         pageIcon!,
                                         color: iconBackgroundColor != null
                                             ? Colors.white
                                             : const Color(0xFF9333EA),
                                         size: 20,
                                       )
                                     : const SizedBox.shrink(),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pageTitle,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      pageSubtitle,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF475569),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (actionButton != null) actionButton!,
                      ],
                    );
                  },
                ),

                // Search Bar in Header (for list screens only)
                if (showSearchInHeader && searchController != null) ...[
                  SizedBox(height: 12.h),
                  _buildSearchBar(context, isMobile),
                  SizedBox(height: 12.h),
                ] else
                  SizedBox(height: 20.h),
                // Page Content
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.grey[300]!, width: 1.w),
            ),
            child: TextField(
              controller: searchController,
              style: TextStyle(color: Colors.grey[800], fontSize: 13.sp),
              decoration: InputDecoration(
                hintText: 'Search here...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13.sp),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        // Filter button (orange square button)
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: const Color(0xFFFF7A00), // Orange color
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: Implement filter functionality
              },
              borderRadius: BorderRadius.circular(10.r),
              child: Icon(Icons.filter_list, color: Colors.white, size: 20.sp),
            ),
          ),
        ),
      ],
    );
  }
}
