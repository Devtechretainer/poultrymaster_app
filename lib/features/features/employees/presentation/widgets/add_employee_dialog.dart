import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'save_employee_dialog.dart';

/// Wrapper for SaveEmployeeDialog that provides AddEmployeeDialog interface
class AddEmployeeDialog extends ConsumerWidget {
  final Function(Map<String, String> employeeData) onAdd;

  const AddEmployeeDialog({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SaveEmployeeDialog(
      onSave: (employeeData, _) => onAdd(employeeData),
    );
  }
}

