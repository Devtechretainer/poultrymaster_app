import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrymaster_app/application/providers/employee_providers.dart';
import 'package:poultrymaster_app/core/theme/input_theme.dart';
import 'package:poultrymaster_app/domain/entities/employee.dart';
import 'package:poultrymaster_app/presentation/widgets/loading_widget.dart';

class SaveEmployeeDialog extends ConsumerStatefulWidget {
  final Function(Map<String, String>, String?) onSave;
  final Employee? employee;

  const SaveEmployeeDialog({
    super.key,
    required this.onSave,
    this.employee,
  });

  @override
  ConsumerState<SaveEmployeeDialog> createState() => _SaveEmployeeDialogState();
}

class _SaveEmployeeDialogState extends ConsumerState<SaveEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _isEditMode => widget.employee != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _firstNameController.text = widget.employee!.firstName;
      _lastNameController.text = widget.employee!.lastName;
      _emailController.text = widget.employee!.email;
      _phoneController.text = widget.employee!.phoneNumber ?? '';
      _userNameController.text = widget.employee!.userName;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final employeeData = {
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'phoneNumber': _phoneController.text.trim(),
      'userName': _userNameController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    widget.onSave(employeeData, widget.employee?.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(employeeControllerProvider).isLoading;
    return AlertDialog(
      title: Text(_isEditMode ? 'Edit Employee' : 'Add Employee'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputTheme.standardDecoration(
                  label: 'First Name *',
                  hint: 'Enter first name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputTheme.standardDecoration(
                  label: 'Last Name *',
                  hint: 'Enter last name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userNameController,
                decoration: InputTheme.standardDecoration(
                  label: 'Username *',
                  hint: 'Enter username',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputTheme.standardDecoration(
                  label: 'Email *',
                  hint: 'Enter email address',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (!_isEditMode)
                TextFormField(
                  controller: _passwordController,
                  decoration: InputTheme.standardDecoration(
                    label: 'Password *',
                    hint: 'Enter password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (!_isEditMode && (value == null || value.trim().isEmpty)) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputTheme.standardDecoration(
                  label: 'Phone Number',
                  hint: 'Enter phone number',
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : _submitForm,
          child: isLoading
              ? const LoadingWidget.small()
              : Text(_isEditMode ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
