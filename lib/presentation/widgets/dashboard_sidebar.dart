import 'package:flutter/material.dart';

/// Presentation Widget - Dashboard Sidebar Navigation
/// Matches the frontend FarmArchive design exactly
class DashboardSidebar extends StatelessWidget {
  final String currentRoute;
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const DashboardSidebar({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 224, // w-56 = 224px (matches frontend)
      color: const Color(0xFF0F172A), // bg-slate-900
      child: Column(
        children: [
          // Logo Section
          Container(
            height: 64, // h-16 = 64px
            padding: const EdgeInsets.symmetric(horizontal: 12), // px-3
            child: Row(
              children: [
                // Colorful Cube Logo (matching frontend SVG)
                _buildCubeLogo(),
                const SizedBox(width: 8), // gap-2
                const Text(
                  'Poultry Core',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14, // text-sm
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ), // px-3 pb-4
              child: ListView(
                children: [
                  // Main Navigation Items
                  _buildNavItem(Icons.home, 'Overview', '/dashboard'),
                  _buildNavItem(Icons.people, 'Customers', '/customers'),
                  _buildNavItem(Icons.eco, 'Flock Batch', '/flock-batch'),
                  _buildNavItem(Icons.eco, 'Flocks', '/flocks'),
                  _buildNavItem(
                    Icons.description,
                    'Production',
                    '/production-records',
                  ),
                  _buildNavItem(
                    Icons.whatshot,
                    'Egg Production',
                    '/egg-production',
                  ),
                  _buildNavItem(Icons.inventory, 'Feed Usage', '/feed-usage'),
                  _buildNavItem(Icons.warning, 'Health', '/health'),
                  _buildNavItem(Icons.inventory_2, 'Inventory', '/inventory'),
                  _buildNavItem(Icons.shopping_cart, 'Supplies', '/supplies'),
                  _buildNavItem(Icons.shopping_bag, 'Sales', '/sales'),
                  _buildNavItem(Icons.attach_money, 'Expenses', '/expenses'),
                  _buildNavItem(Icons.book, 'Resources', '/resources'),
                  _buildNavItem(
                    Icons.person_outline,
                    'Employees',
                    '/employees',
                  ),

                  const SizedBox(
                    height: 28,
                  ), // gap-y-7 spacing before System section
                  // System Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      'SYSTEM',
                      style: TextStyle(
                        color: Color(0xFF94A3B8), // text-slate-400
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.05,
                      ),
                    ),
                  ),

                  _buildNavItem(Icons.bar_chart, 'Reports', '/reports'),
                  _buildNavItem(Icons.account_circle, 'Account', '/profile'),
                  _buildNavItem(Icons.home_work, 'Houses', '/houses'),
                ],
              ),
            ),
          ),

          // Logout Button
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFF1E293B),
                  width: 1,
                ), // border-slate-800
              ),
            ),
            padding: const EdgeInsets.all(16), // p-4
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onLogout,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Color(0xFFCBD5E1), // text-slate-300
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Logout',
                          style: TextStyle(
                            color: Color(0xFFCBD5E1), // text-slate-300
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

  Widget _buildCubeLogo() {
    return CustomPaint(size: const Size(40, 40), painter: _CubeLogoPainter());
  }

  Widget _buildNavItem(IconData icon, String label, String route) {
    final isActive = currentRoute == route;
    return Container(
      margin: const EdgeInsets.only(bottom: 4), // space-y-1
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF1E293B)
            : Colors.transparent, // bg-slate-800 when active
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onNavigate(route),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ), // p-2
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive
                      ? Colors.white
                      : const Color(0xFFCBD5E1), // text-white or text-slate-300
                  size: 24, // h-6 w-6
                ),
                const SizedBox(width: 12), // gap-x-3
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFFCBD5E1),
                    fontSize: 14, // text-sm
                    fontWeight: FontWeight.w600, // font-semibold
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Painter for the colorful cube logo matching frontend SVG
class _CubeLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Blue top face (#0066FF)
    paint.color = const Color(0xFF0066FF);
    final topPath = Path()
      ..moveTo(20, 5)
      ..lineTo(32, 12)
      ..lineTo(20, 19)
      ..lineTo(8, 12)
      ..close();
    canvas.drawPath(topPath, paint);

    // Yellow left face (#FFB800)
    paint.color = const Color(0xFFFFB800);
    final leftPath = Path()
      ..moveTo(8, 12)
      ..lineTo(8, 26)
      ..lineTo(20, 33)
      ..lineTo(20, 19)
      ..close();
    canvas.drawPath(leftPath, paint);

    // Red right face (#FF3B30)
    paint.color = const Color(0xFFFF3B30);
    final rightPath = Path()
      ..moveTo(20, 19)
      ..lineTo(20, 33)
      ..lineTo(32, 26)
      ..lineTo(32, 12)
      ..close();
    canvas.drawPath(rightPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
