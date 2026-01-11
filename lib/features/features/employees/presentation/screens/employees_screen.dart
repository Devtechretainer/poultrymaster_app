import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrymaster_app/application/providers/auth_providers.dart';
import 'package:poultrymaster_app/application/providers/employee_providers.dart';
import 'package:poultrymaster_app/application/states/employee_state.dart';
import 'package:poultrymaster_app/domain/entities/create_employee_request.dart';
import 'package:poultrymaster_app/domain/entities/employee.dart';

import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';
import '../../../../../presentation/widgets/info_item_widget.dart';
import '../widgets/add_employee_dialog.dart';
import '../widgets/save_employee_dialog.dart';

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
    Future.microtask(
      () => ref.read(employeeControllerProvider.notifier).fetchEmployees(),
    );
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
            final authState = ref.read(authControllerProvider);
            final farmId = authState.user?.farmId ?? authState.user?.id ?? '';
            final farmName = authState.user?.farmName ?? 'My Farm';
            final request = CreateEmployeeRequest(
              firstName: employeeData['firstName']!,
              lastName: employeeData['lastName']!,
              userName: employeeData['userName']!,
              email: employeeData['email']!,
              phoneNumber: employeeData['phoneNumber'],
              password: employeeData['password']!,
              farmId: farmId,
              farmName: farmName,
            );
            ref
                .read(employeeControllerProvider.notifier)
                .createEmployee(request);
          },
        );
      },
    );
  }

  void _showEmployeeDetail(Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Employee Details',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Employee Information
                  InfoItemWidget(
                    icon: Icons.person_outline,
                    label: 'Full Name',
                    value: '${employee.firstName} ${employee.lastName}',
                  ),
                  const SizedBox(height: 16),
                  InfoItemWidget(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: employee.email,
                  ),
                  const SizedBox(height: 16),
                  InfoItemWidget(
                    icon: Icons.person_outline,
                    label: 'Username',
                    value: employee.userName,
                  ),
                  const SizedBox(height: 16),
                  if (employee.phoneNumber != null &&
                      employee.phoneNumber!.isNotEmpty) ...[
                    InfoItemWidget(
                      icon: Icons.phone_outlined,
                      label: 'Phone Number',
                      value: employee.phoneNumber!,
                    ),
                    const SizedBox(height: 16),
                  ],
                  InfoItemWidget(
                    icon: Icons.business_outlined,
                    label: 'Farm ID',
                    value: employee.farmId,
                  ),
                  const SizedBox(height: 16),
                  InfoItemWidget(
                    icon: Icons.calendar_today_outlined,
                    label: 'Joined Date',
                    value: employee.createdDate.toLocal().toString().split(
                      ' ',
                    )[0],
                  ),
                  const SizedBox(height: 24),
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close detail dialog
                        _showEditEmployeeDialog(employee);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Edit Employee'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditEmployeeDialog(Employee employee) {
    final authState = ref.read(authControllerProvider);
    final user = authState.user;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated.')));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SaveEmployeeDialog(
          employee: employee,
          onSave: (data, employeeId) {
            if (employeeId == null) {
              // Create - shouldn't happen here
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
              ref
                  .read(employeeControllerProvider.notifier)
                  .createEmployee(request);
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
                isStaff: employee.isStaff,
                emailConfirmed: employee.emailConfirmed,
                createdDate: employee.createdDate,
              );
              ref
                  .read(employeeControllerProvider.notifier)
                  .updateEmployee(updatedEmployee);
            }
          },
        );
      },
    );
  }

  void _deleteEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text(
          'Are you sure you want to delete ${employee.firstName} ${employee.lastName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(employeeControllerProvider.notifier)
                  .deleteEmployee(employee.id);
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
    final employeeState = ref.watch(employeeControllerProvider);

    ref.listen<EmployeeState>(employeeControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: employeeState.employees.length,
      itemBuilder: (context, index) {
        final employee = employeeState.employees[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF2563EB),
              child: Text(
                '${employee.firstName[0]}${employee.lastName[0]}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              '${employee.firstName} ${employee.lastName}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(employee.email),
                if (employee.phoneNumber != null &&
                    employee.phoneNumber!.isNotEmpty)
                  Text(employee.phoneNumber!),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'view') {
                  _showEmployeeDetail(employee);
                } else if (value == 'edit') {
                  _showEditEmployeeDialog(employee);
                } else if (value == 'delete') {
                  _deleteEmployee(employee);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 18),
                      SizedBox(width: 8),
                      Text('View Details'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              _showEmployeeDetail(employee);
            },
          ),
        );
      },
    );
  }
}
