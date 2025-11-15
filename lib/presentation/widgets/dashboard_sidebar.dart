import 'package:flutter/material.dart';

/// Presentation Widget - Dashboard Sidebar Navigation
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
      width: 250,
      color: const Color(0xFF1A1F2E), // Dark blue
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.amber],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.agriculture, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Poult',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _NavItem(
                  icon: Icons.home,
                  title: 'Overview',
                  isSelected: currentRoute == '/overview',
                  onTap: () => onNavigate('/overview'),
                ),
                _NavItem(
                  icon: Icons.people,
                  title: 'Customers',
                  onTap: () => onNavigate('/customers'),
                ),
                _NavItem(
                  icon: Icons.groups,
                  title: 'Flock Batch',
                  onTap: () => onNavigate('/flock-batch'),
                ),
                _NavItem(
                  icon: Icons.pets,
                  title: 'Flocks',
                  onTap: () => onNavigate('/flocks'),
                ),
                _NavItem(
                  icon: Icons.description,
                  title: 'Production',
                  onTap: () => onNavigate('/production'),
                ),
                _NavItem(
                  icon: Icons.circle,
                  title: 'Egg Production',
                  onTap: () => onNavigate('/egg-production'),
                ),
                _NavItem(
                  icon: Icons.inventory,
                  title: 'Feed Usage',
                  onTap: () => onNavigate('/feed-usage'),
                ),
                _NavItem(
                  icon: Icons.warning,
                  title: 'Health',
                  onTap: () => onNavigate('/health'),
                ),
                _NavItem(
                  icon: Icons.inventory_2,
                  title: 'Inventory',
                  onTap: () => onNavigate('/inventory'),
                ),
                _NavItem(
                  icon: Icons.shopping_cart,
                  title: 'Supplies',
                  onTap: () => onNavigate('/supplies'),
                ),
                _NavItem(
                  icon: Icons.point_of_sale,
                  title: 'Sales',
                  onTap: () => onNavigate('/sales'),
                ),
                _NavItem(
                  icon: Icons.payments,
                  title: 'Expenses',
                  onTap: () => onNavigate('/expenses'),
                ),
                _NavItem(
                  icon: Icons.book,
                  title: 'Resources',
                  onTap: () => onNavigate('/resources'),
                ),
                _NavItem(
                  icon: Icons.people_outline,
                  title: 'Employees',
                  onTap: () => onNavigate('/employees'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(color: Colors.white24),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'SYSTEM',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _NavItem(
                  icon: Icons.bar_chart,
                  title: 'Reports',
                  onTap: () => onNavigate('/reports'),
                ),
                _NavItem(
                  icon: Icons.account_circle,
                  title: 'Account',
                  onTap: () => onNavigate('/account'),
                ),
                _NavItem(
                  icon: Icons.home_work,
                  title: 'Houses',
                  onTap: () => onNavigate('/houses'),
                ),
              ],
            ),
          ),
          // Logout Button
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[700] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
