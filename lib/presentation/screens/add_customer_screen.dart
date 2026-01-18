import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      backgroundColor: const Color(0xFFF1F5F9), // bg-slate-100
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[900], size: 24.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name field (required)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Name *',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputTheme.standardDecoration(
                        label: '',
                        hint: 'Enter customer name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.grey[400],
                          size: 20.sp,
                        ),
                      ).copyWith(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Customer name is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                      SizedBox(height: 12.h),

                // Email field (optional)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputTheme.standardDecoration(
                        label: '',
                        hint: 'Enter email address',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey[400],
                          size: 20.sp,
                        ),
                      ).copyWith(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
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
                  ],
                ),
                      SizedBox(height: 12.h),

                // Phone field (optional)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _phoneController,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputTheme.standardDecoration(
                        label: '',
                        hint: 'Enter phone number',
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.grey[400],
                          size: 20.sp,
                        ),
                      ).copyWith(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
                      SizedBox(height: 12.h),

                // Address field (optional)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _addressController,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputTheme.textAreaDecoration(
                        label: '',
                        hint: 'Enter address',
                      ).copyWith(
                        contentPadding: EdgeInsets.all(12.w),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
                      SizedBox(height: 12.h),

                // City field (optional)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'City',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _cityController,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputTheme.standardDecoration(
                        label: '',
                        hint: 'Enter city',
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: Colors.grey[400],
                          size: 20.sp,
                        ),
                      ).copyWith(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ],
                ),
                      SizedBox(height: 12.h),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF14B8A6), // Teal-green
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const LoadingWidget.small()
                        : Text(
                            _isEditMode ? 'Update Customer' : 'Save Customer',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
