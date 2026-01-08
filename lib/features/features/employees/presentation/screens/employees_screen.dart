import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrymaster_app/application/providers/employee_providers.dart';
import 'package:poultrymaster_app/domain/entities/create_employee_request.dart'; // Re-add this import

import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';
import '../widgets/add_employee_dialog.dart';
import 'package:poultrymaster_app/application/states/employee_state.dart';

/// Employees Screen
class EmployeesScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const EmployeesScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch employees when the screen is first loaded
    Future.microtask(() => ref.read(employeeControllerProvider.notifier).fetchEmployees());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddEmployeeDialog(
          onAdd: (employeeData) {
            final request = CreateEmployeeRequest(
              firstName: employeeData['firstName']!,
              lastName: employeeData['lastName']!,
              userName: employeeData['userName']!,
              email: employeeData['email']!,
              phoneNumber: employeeData['phoneNumber']!,
              password: employeeData['password']!,
            );
            ref.read(employeeControllerProvider.notifier).createEmployee(request);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeeState = ref.watch(employeeControllerProvider);

    ref.listen<EmployeeState>(employeeControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

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
        onPressed: _showAddEmployeeDialog,
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
      child: _buildChild(employeeState),
    );
  }

  Widget _buildChild(EmployeeState employeeState) {
    if (employeeState.isLoading && employeeState.employees.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (employeeState.employees.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.person_outline,
        title: 'No employees found',
        subtitle: 'Get started by adding your first employee',
        buttonLabel: 'Add Your First Employee',
        onButtonPressed: _showAddEmployeeDialog,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        itemCount: employeeState.employees.length,
        itemBuilder: (context, index) {
          final employee = employeeState.employees[index];
          return ListTile(
            title: Text('${employee.firstName} ${employee.lastName}'),
            subtitle: Text(employee.email),
          );
        },
      ),
    );
  }
}
