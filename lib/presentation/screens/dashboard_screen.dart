import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/dashboard_providers.dart';
import '../../application/states/dashboard_state.dart';
import '../widgets/dashboard_sidebar.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/summary_card_widget.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/quick_actions_section.dart';
import 'login_screen.dart';

/// Presentation Screen - Dashboard/Overview
/// Main dashboard screen matching web version
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final farmId = user?.farmId ?? user?.id ?? '';

    final dashboardState = ref.watch(
      dashboardControllerProvider(farmId.isEmpty ? 'default' : farmId),
    );

    // For mobile, use drawer instead of sidebar
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        if (isMobile) {
          // Mobile: Use drawer
          return Scaffold(
            drawer: DashboardSidebar(
              currentRoute: '/overview',
              onNavigate: (route) {
                Navigator.pop(context); // Close drawer
                // Handle navigation
              },
              onLogout: () async {
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
            ),
            body: _buildMainContent(
              context,
              ref,
              user,
              farmId,
              dashboardState,
              isMobile: true,
            ),
          );
        }

        // Desktop: Use sidebar
        return Scaffold(
          body: Row(
            children: [
              // Left Sidebar
              DashboardSidebar(
                currentRoute: '/overview',
                onNavigate: (route) {
                  // Handle navigation
                },
                onLogout: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
              ),
              // Main Content Area
              _buildMainContent(
                context,
                ref,
                user,
                farmId,
                dashboardState,
                isMobile: false,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    WidgetRef ref,
    user,
    String farmId,
    DashboardState dashboardState, {
    required bool isMobile,
  }) {
    return Expanded(
      child: Column(
        children: [
          // Header
          DashboardHeader(
            user: user,
            showDrawerButton: isMobile,
            onDrawerPressed: () {
              Scaffold.of(context).openDrawer();
            },
            onSearch: (query) {
              // Handle search
            },
          ),
          // Main Content
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Cards Grid
                    if (dashboardState.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (dashboardState.error != null)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Text(
                                'Error: ${dashboardState.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(
                                        dashboardControllerProvider(
                                          farmId.isEmpty ? 'default' : farmId,
                                        ).notifier,
                                      )
                                      .loadDashboard();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      // Summary Cards
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Responsive: 4 columns on desktop, 2 on tablet, 2 on mobile
                          final crossAxisCount = constraints.maxWidth > 1200
                              ? 4
                              : constraints.maxWidth > 600
                              ? 3
                              : 2;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.2,
                                ),
                            itemCount: dashboardState.cards.length,
                            itemBuilder: (context, index) {
                              return SummaryCardWidget(
                                card: dashboardState.cards[index],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      // Bottom Section: Recent Activity and Quick Actions
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Stack vertically on small screens
                          if (constraints.maxWidth < 800) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                RecentActivitySection(),
                                const SizedBox(height: 16),
                                QuickActionsSection(),
                              ],
                            );
                          }
                          // Side by side on larger screens
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: RecentActivitySection()),
                              const SizedBox(width: 16),
                              Expanded(flex: 1, child: QuickActionsSection()),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
