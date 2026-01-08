import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrymaster_app/application/providers/auth_providers.dart';
import 'package:poultrymaster_app/application/providers/employee_providers.dart';
import 'package:poultrymaster_app/domain/entities/create_employee_request.dart';
import 'package:poultrymaster_app/domain/entities/employee.dart';
import 'package:poultrymaster_app/features/features/employees/presentation/widgets/save_employee_dialog.dart';
import 'package:poultrymaster_app/presentation/widgets/employee_list.dart';
import 'package:poultrymaster_app/presentation/widgets/loading_widget.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';

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
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(employeeControllerProvider.notifier).fetchEmployees();
      ref.listenManual(employeeControllerProvider, (previous, next) {
        if (next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${next.error}')),
          );
        } else if (previous != null && !next.isLoading) {
          if (previous.employees.length < next.employees.length) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Employee added successfully!')),
            );
          } else if (previous.employees.length > next.employees.length) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Employee deleted successfully!')),
            );
          } else if (previous.employees.length == next.employees.length && previous.employees.isNotEmpty && next.employees.isNotEmpty) {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Employee updated successfully!')),
            );
          }
        }
      });
    });
  }

  void _showSaveEmployeeDialog(Employee? employee) {
    final user = ref.read(authControllerProvider).user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SaveEmployeeDialog(
          employee: employee,
          onSave: (data, employeeId) {
            if (employeeId == null) {
              // Create
              final request = CreateEmployeeRequest(
                email: data['email']!,
                firstName: data['firstName']!,
                lastName: data['lastName']!,
                phoneNumber: data['phoneNumber'],
                userName: data['userName']!,
                password: data['password']!,
                farmId: user.farmId,
                farmName: user.farmName,
              );
              ref.read(employeeControllerProvider.notifier).createEmployee(request);
            } else {
              // Update
              final updatedEmployee = Employee(
                id: employeeId,
                firstName: data['firstName']!,
                lastName: data['lastName']!,
                email: data['email']!,
                userName: data['userName']!,
                phoneNumber: data['phoneNumber'],
                farmId: user.farmId,
                farmName: user.farmName,
                isStaff: true,
                emailConfirmed: employee!.emailConfirmed,
                createdDate: employee.createdDate,
              );
              ref.read(employeeControllerProvider.notifier).updateEmployee(updatedEmployee);
            }
          },
        );
      },
    );
  }

  void _onDelete(String employeeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: const Text('Are you sure you want to delete this employee?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(employeeControllerProvider.notifier).deleteEmployee(employeeId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final employeeState = ref.watch(employeeControllerProvider);

    return BasePageScreen(
      currentRoute: '/employees',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Employees',
      pageSubtitle: 'Manage your farm employees',
      pageIcon: Icons.person_outline,
      iconBackgroundColor: const Color(0xFFECFDF5),
      searchController: searchController,
      actionButton: ElevatedButton.icon(
        onPressed: employeeState.isLoading ? null : () => _showSaveEmployeeDialog(null),
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
      child: employeeState.isLoading && employeeState.employees.isEmpty
          ? const LoadingWidget()
          : employeeState.employees.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.person_outline,
                  title: 'No employees found',
                  subtitle: 'Start managing employees by adding your first team member',
                  buttonLabel: 'Add Your First Employee',
                  onButtonPressed: employeeState.isLoading ? null : () => _showSaveEmployeeDialog(null),
                )
              : EmployeeList(
                  employees: employeeState.employees,
                  onEdit: _showSaveEmployeeDialog,
                  onDelete: _onDelete,
                ),
    );
  }
}
