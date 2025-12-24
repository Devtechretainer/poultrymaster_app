import 'package:flutter/material.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';

/// Employees Screen
class EmployeesScreen extends StatelessWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const EmployeesScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return BasePageScreen(
      currentRoute: '/employees',
      onNavigate: onNavigate,
      onLogout: onLogout,
      pageTitle: 'Employees',
      pageSubtitle: 'Manage your farm employees',
      pageIcon: Icons.person_outline,
      iconBackgroundColor: const Color(0xFFECFDF5),
      searchController: searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {
          // TODO: Navigate to add employee
        },
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Employee',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: EmptyStateWidget(
        icon: Icons.person_outline,
        title: 'No employees found',
        subtitle: 'Start managing employees by adding your first team member',
        buttonLabel: 'Add Your First Employee',
        onButtonPressed: () {
          // TODO: Navigate to add employee
        },
      ),
    );
  }
}
