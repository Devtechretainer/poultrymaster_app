import 'package:flutter/material.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';

/// Health Screen
class HealthScreen extends StatelessWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const HealthScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return BasePageScreen(
      currentRoute: '/health',
      onNavigate: onNavigate,
      onLogout: onLogout,
      pageTitle: 'Health',
      pageSubtitle: 'Monitor flock health records',
      pageIcon: Icons.warning,
      iconBackgroundColor: const Color(0xFFFEF2F2),
      searchController: searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {
          // TODO: Navigate to add health record
        },
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Record',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: EmptyStateWidget(
        icon: Icons.warning,
        title: 'No health records found',
        subtitle: 'Start monitoring health by adding your first record',
        buttonLabel: 'Add Your First Record',
        onButtonPressed: () {
          // TODO: Navigate to add health record
        },
      ),
    );
  }
}
