import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';

/// Health Screen
class HealthScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const HealthScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _records = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/health',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Health',
      pageSubtitle: 'Monitor flock health and medical records',
      pageIcon: Icons.warning,
      iconBackgroundColor: const Color(0xFFFEE2E2), // bg-red-100
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Record',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // bg-blue-600
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _records.isEmpty
          ? EmptyStateWidget(
              icon: Icons.warning,
              title: 'No health records found',
              subtitle: 'Get started by adding your first health record',
              buttonLabel: 'Add Your First Record',
              onButtonPressed: () {},
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Health Records List')),
            ),
    );
  }
}
