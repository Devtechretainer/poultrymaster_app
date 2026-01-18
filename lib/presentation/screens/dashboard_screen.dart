import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/dashboard_providers.dart';
import '../../application/states/dashboard_state.dart';
import '../widgets/dashboard_sidebar.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/summary_card_widget.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/app_navigator.dart';
import '../widgets/loading_widget.dart';
import 'login_screen.dart';

/// Presentation Screen - Dashboard/Overview
/// Main dashboard screen matching web version
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _currentRoute = '/dashboard';
  late final TextEditingController _searchController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleNavigate(String route) {
    setState(() {
      _currentRoute = route;
    });

    // Navigate to the new screen
    final screen = AppNavigator.getScreenForRoute(
      route,
      ref,
      _handleNavigate,
      _handleLogout,
    );

    if (screen != null && mounted) {
      // If on mobile, close drawer first, then navigate
      if (MediaQuery.of(context).size.width < 800) {
        Navigator.pop(context); // Close drawer
        // Small delay to ensure drawer closes before navigation
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => screen));
          }
        });
      } else {
        // Desktop: navigate directly
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
      }
    }
  }

  Future<void> _handleLogout() async {
    await ref.read(authControllerProvider.notifier).logout();
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
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
            key: _scaffoldKey,
            drawer: DashboardSidebar(
              currentRoute: _currentRoute,
              onNavigate: _handleNavigate,
              onLogout: _handleLogout,
            ),
            drawerEdgeDragWidth: MediaQuery.of(
              context,
            ).size.width, // Enable swipe from edge
            body: _buildMainContent(
              context,
              ref,
              user,
              farmId,
              dashboardState,
              isMobile: true,
              onMenuPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          );
        }

        // Desktop: Use sidebar
        return Scaffold(
          body: Row(
            children: [
              // Left Sidebar
              DashboardSidebar(
                currentRoute: _currentRoute,
                onNavigate: _handleNavigate,
                onLogout: _handleLogout,
              ),
              // Main Content Area
              Expanded(
                child: _buildMainContent(
                  context,
                  ref,
                  user,
                  farmId,
                  dashboardState,
                  isMobile: false,
                  onMenuPressed: null, // Not needed on desktop
                ),
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
    VoidCallback? onMenuPressed,
  }) {
    return Column(
      children: [
        // Header
        DashboardHeader(
          searchController: _searchController,
          username: user?.username,
          roleLabel:
              'Admin', // Default role, can be updated based on user permissions
          showMenuButton: isMobile, // Show menu button only on mobile
          onMenuPressed: onMenuPressed,
        ),
        // Main Content - Scrollable for responsive design
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // Refresh dashboard data
              await ref
                  .read(
                    dashboardControllerProvider(
                      farmId.isEmpty ? 'default' : farmId,
                    ).notifier,
                  )
                  .loadDashboard();
            },
            child: Container(
              color: Colors.grey[100],
              child: SingleChildScrollView(
                // Enhanced scroll physics for responsive scrolling
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                // Add extra padding at bottom for better scroll experience
                padding: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Cards Grid
                      if (dashboardState.isLoading)
                        const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: LoadingWidget.large(),
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
                        // Summary Cards - Mobile-first responsive grid matching POC design
                        _SummaryCardsGrid(
                          cards: dashboardState.cards,
                          isMobile: isMobile,
                          onNavigate: _handleNavigate,
                        ),
                        const SizedBox(height: 24),
                        // Bottom Section: Recent Activity and Quick Actions
                        _BottomSection(
                          isMobile: isMobile,
                          onNavigate: _handleNavigate,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Optimized summary cards grid widget to reduce rebuilds
class _SummaryCardsGrid extends StatelessWidget {
  final List<SummaryCard> cards;
  final bool isMobile;
  final Function(String) onNavigate;

  const _SummaryCardsGrid({
    required this.cards,
    required this.isMobile,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 2x2 grid layout for better user experience
        final screenWidth = constraints.maxWidth;
        final isMobileScreen = screenWidth < 600;

        // Always use 2 columns for 2x2 grid
        final crossAxisCount = 2;

        // Aspect ratio adjusted for 2x2 grid layout - slightly taller to prevent overflow
        final childAspectRatio = isMobileScreen
            ? 1.35 // Slightly taller cards on mobile to prevent overflow
            : 1.45; // Standard aspect ratio for 2x2 grid with extra height

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return SummaryCardWidget(
              key: ValueKey('summary_card_$index'),
              card: card,
              isMobile: isMobileScreen,
              onTap: card.route != null ? () => onNavigate(card.route!) : null,
            );
          },
        );
      },
    );
  }
}

/// Optimized bottom section widget to reduce rebuilds
class _BottomSection extends StatelessWidget {
  final bool isMobile;
  final Function(String) onNavigate;

  const _BottomSection({required this.isMobile, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Stack vertically on small screens
        if (constraints.maxWidth < 800) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RecentActivitySection(onNavigate: onNavigate),
              const SizedBox(height: 16),
              QuickActionsSection(),
            ],
          );
        }
        // Side by side on larger screens
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: RecentActivitySection(onNavigate: onNavigate),
            ),
            const SizedBox(width: 16),
            const Expanded(flex: 1, child: QuickActionsSection()),
          ],
        );
      },
    );
  }
}
