import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/customer_providers.dart';
import '../../domain/entities/customer.dart';
import '../../core/theme/input_theme.dart';
import '../widgets/loading_widget.dart';

/// Add or Edit Customer Screen
class AddCustomerScreen extends ConsumerStatefulWidget {
  final Customer? customer; // Make customer optional

  const AddCustomerScreen({super.key, this.customer});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  bool get _isEditMode => widget.customer != null;

  @override
  void initState() {
    super.initState();
    // Pre-fill form if in edit mode
    if (_isEditMode) {
      final customer = widget.customer!;
      _nameController.text = customer.name;
      _emailController.text = customer.contactEmail ?? '';
      _phoneController.text = customer.contactPhone ?? '';
      _addressController.text = customer.address ?? '';
      _cityController.text = customer.city ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = ref.read(authControllerProvider);
    final user = authState.user;
    final userId = user?.id ?? '';
    final farmId = user?.farmId ?? user?.id ?? '';

    if (userId.isEmpty || farmId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User information not found. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final customerData = Customer(
      customerId: widget.customer?.customerId, // Keep original ID for updates
      farmId: farmId,
      userId: userId,
      name: _nameController.text.trim(),
      contactEmail: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      contactPhone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      city: _cityController.text.trim().isEmpty
          ? null
          : _cityController.text.trim(),
      createdDate: widget.customer?.createdDate,
    );

    final controller = ref.read(customerControllerProvider.notifier);
    final success = _isEditMode
        ? await controller.updateCustomer(customerData)
        : await controller.createCustomer(customerData);

    if (mounted) {
      final message = _isEditMode ? 'Customer updated' : 'Customer added';
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$message successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to customers list
      } else {
        final error = ref.read(customerControllerProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Failed to $message'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(customerControllerProvider).isLoading;
    final title = _isEditMode ? 'Edit Customer' : 'Add Customer';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name field (required)
                      TextFormField(
                        controller: _nameController,
                        decoration: InputTheme.standardDecoration(
                          label: 'Customer Name *',
                          hint: 'Enter customer name',
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Customer name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email field (optional)
                      TextFormField(
                        controller: _emailController,
                        decoration: InputTheme.standardDecoration(
                          label: 'Email',
                          hint: 'Enter email address',
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null &&
                              value.trim().isNotEmpty &&
                              !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone field (optional)
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputTheme.standardDecoration(
                          label: 'Phone',
                          hint: 'Enter phone number',
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Address field (optional)
                      TextFormField(
                        controller: _addressController,
                        decoration: InputTheme.textAreaDecoration(
                          label: 'Address',
                          hint: 'Enter address',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // City field (optional)
                      TextFormField(
                        controller: _cityController,
                        decoration: InputTheme.standardDecoration(
                          label: 'City',
                          hint: 'Enter city',
                          prefixIcon: const Icon(
                            Icons.location_city,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submitForm,
                          style: FormButtonStyle.primary(),
                          child: isLoading
                              ? const LoadingWidget.small()
                              : Text(
                                  _isEditMode
                                      ? 'Update Customer'
                                      : 'Save Record',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
