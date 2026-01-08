import 'package:flutter/material.dart';
import 'package:poultrymaster_app/domain/entities/employee.dart';

class EmployeeListItem extends StatelessWidget {
  final Employee employee;
  final Function(Employee) onEdit;
  final Function(String) onDelete;

  const EmployeeListItem({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(employee.firstName.isNotEmpty ? employee.firstName[0] : '?'),
        ),
        title: Text('${employee.firstName} ${employee.lastName}'),
        subtitle: Text('${employee.email}\n${employee.phoneNumber ?? ''}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => onEdit(employee),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(employee.id),
            ),
          ],
        ),
      ),
    );
  }
}
