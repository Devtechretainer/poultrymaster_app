import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';

/// Employees Screen
class EmployeesScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const EmployeesScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _employees = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/employees',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Employees',
      pageSubtitle: 'Manage your farm employees',
      pageIcon: Icons.person_outline,
      iconBackgroundColor: const Color(0xFFE0E7FF), // bg-indigo-100
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Employee',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // bg-blue-600
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _employees.isEmpty
          ? EmptyStateWidget(
              icon: Icons.person_outline,
              title: 'No employees found',
              subtitle: 'Get started by adding your first employee',
              buttonLabel: 'Add Your First Employee',
              onButtonPressed: () {},
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Employees List')),
            ),
    );
  }
}
