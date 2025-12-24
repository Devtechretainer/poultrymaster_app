import 'package:flutter/material.dart';
import '../widgets/base_page_screen.dart';

/// Reports Screen
class ReportsScreen extends StatelessWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const ReportsScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return BasePageScreen(
      currentRoute: '/reports',
      onNavigate: onNavigate,
      onLogout: onLogout,
      pageTitle: 'Reports',
      pageSubtitle: 'View farm analytics and reports',
      pageIcon: Icons.bar_chart,
      iconBackgroundColor: const Color(0xFFF0F9FF),
      searchController: searchController,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Reports',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Farm reports and analytics will be available here',
                style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
