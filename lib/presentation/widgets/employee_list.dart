import 'package:flutter/material.dart';
import 'package:poultrymaster_app/domain/entities/employee.dart';
import 'package:poultrymaster_app/presentation/widgets/employee_list_item.dart';

class EmployeeList extends StatelessWidget {
  final List<Employee> employees;
  final Function(Employee) onEdit;
  final Function(String) onDelete;

  const EmployeeList({
    super.key,
    required this.employees,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return EmployeeListItem(
          employee: employee,
          onEdit: onEdit,
          onDelete: onDelete,
        );
      },
    );
  }
}
