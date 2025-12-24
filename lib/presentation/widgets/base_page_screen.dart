import 'package:flutter/material.dart';
import 'dashboard_sidebar.dart';
import 'dashboard_header.dart';

/// Base Page Screen Template
/// Matches the frontend FarmArchive design exactly
class BasePageScreen extends StatelessWidget {
  final String currentRoute;
  final Function(String) onNavigate;
  final VoidCallback onLogout;
  final String pageTitle;
  final String pageSubtitle;
  final IconData pageIcon;
  final Color? iconBackgroundColor;
  final Widget? actionButton;
  final Widget child;
  final TextEditingController? searchController;
  final String? username;
  final String? roleLabel;

  const BasePageScreen({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
    required this.onLogout,
    required this.pageTitle,
    required this.pageSubtitle,
    required this.pageIcon,
    this.iconBackgroundColor,
    this.actionButton,
    required this.child,
    this.searchController,
    this.username,
    this.roleLabel,
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
          searchController: searchController,
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
                                child: Icon(
                                  pageIcon,
                                  color: iconBackgroundColor != null
                                      ? Colors.white
                                      : const Color(0xFF9333EA),
                                  size: 20,
                                ),
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
                                child: Icon(
                                  pageIcon,
                                  color: iconBackgroundColor != null
                                      ? Colors.white
                                      : const Color(0xFF9333EA),
                                  size: 20,
                                ),
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

                const SizedBox(height: 24),
                // Page Content
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
