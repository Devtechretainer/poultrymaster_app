import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/expense_providers.dart';
import '../../domain/entities/expense.dart';
import '../../application/providers/flock_providers.dart';
import '../../domain/entities/flock.dart';
import '../widgets/custom_dropdown_button_form_field.dart';
import '../widgets/loading_widget.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/theme/input_theme.dart';

class AddEditExpenseScreen extends ConsumerStatefulWidget {
  final Expense? expense;

  const AddEditExpenseScreen({super.key, this.expense});

  @override
  ConsumerState<AddEditExpenseScreen> createState() =>
      _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends ConsumerState<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedExpenseDate;
  Flock? _selectedFlock;
  String? _selectedCategory;
  String? _selectedPaymentMethod;

  final List<String> _expenseCategories = [
    'Feed',
    'Veterinary',
    'Equipment',
    'Labor',
    'Utilities',
  ];
  final List<String> _paymentMethods = [
    'Cash',
    'Credit card',
    'Bank Transfer',
    'Check',
  ];

  bool get _isEditMode => widget.expense != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final expense = widget.expense!;
      _descriptionController.text = expense.description ?? '';
      _amountController.text = expense.amount.toString();
      _selectedExpenseDate = expense.expenseDate;
      _selectedCategory = expense.category;
      _selectedPaymentMethod = expense.paymentMethod;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectExpenseDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedExpenseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedExpenseDate) {
      if (mounted) {
        setState(() {
          _selectedExpenseDate = picked;
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedExpenseDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense Date is required.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (_selectedFlock == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Flock is required.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (_selectedCategory == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category is required.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (_selectedPaymentMethod == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Method is required.'),
            backgroundColor: Colors.red,
          ),
        );
      }
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

    final expenseData = Expense(
      expenseId: widget.expense?.expenseId ?? 0,
      farmId: farmId,
      userId: userId,
      expenseDate: _selectedExpenseDate!,
      category: _selectedCategory!,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      paymentMethod: _selectedPaymentMethod!,
      flockId: _selectedFlock!.flockId,
      createdDate: widget.expense?.createdDate ?? DateTime.now(),
    );

    final controller = ref.read(expenseControllerProvider.notifier);
    final success = _isEditMode
        ? await controller.updateExpense(expenseData)
        : await controller.createExpense(expenseData);

    if (mounted) {
      final message = _isEditMode ? 'Expense updated' : 'Expense added';
      if (success) {
        ToastUtils.showSuccess('$message successfully!');
        Navigator.pop(context);
      } else {
        final error = ref.read(expenseControllerProvider).error;
        ToastUtils.showError(error ?? 'Failed to $message');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(expenseControllerProvider).isLoading;
    final title = _isEditMode ? 'Edit Expense' : 'Add Expense';

    final flockState = ref.watch(flockControllerProvider);
    final flocks = flockState.flocks;
    final flocksLoading = flockState.isLoading;

    if (_isEditMode && _selectedFlock == null && flocks.isNotEmpty) {
      final selected = flocks.firstWhereOrNull(
        (flock) => flock.flockId == widget.expense!.flockId,
      );
      if (selected != null) {
        Future.microtask(() {
          if (mounted) {
            setState(() => _selectedFlock = selected);
          }
        });
      }
    }

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
                // Flock dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flock *',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CustomDropdownButtonFormField<Flock>(
                      value: _selectedFlock,
                      decoration: InputTheme.dropdownDecoration(
                        label: '',
                      ).copyWith(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      items: flocksLoading
                          ? []
                          : flocks.map((Flock flock) {
                              return DropdownMenuItem<Flock>(
                                value: flock,
                                child: Text(flock.name),
                              );
                            }).toList(),
                      onChanged: flocksLoading
                          ? null
                          : (Flock? newValue) {
                              setState(() {
                                _selectedFlock = newValue;
                              });
                            },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a flock';
                        }
                        return null;
                      },
                      isLoading: flocksLoading,
                      loadingMessage: 'Loading flocks...',
                      emptyMessage: flockState.error != null
                          ? 'Error: ${flockState.error}'
                          : 'No flocks found. Please add a flock first.',
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Expense Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expense Date *',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                        onTap: () => _selectExpenseDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(
                              text: _selectedExpenseDate == null
                                  ? ''
                                  : '${_selectedExpenseDate!.toLocal()}'
                                      .split(' ')[0],
                            ),
                            style: TextStyle(fontSize: 14.sp),
                            decoration: InputTheme.dateDecoration(
                              label: '',
                              hint: 'DD/MM/YYYY',
                            ).copyWith(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 14.h,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                            ),
                            validator: (value) {
                              if (_selectedExpenseDate == null) {
                                return 'Expense Date is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Category
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category *',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputTheme.dropdownDecoration(
                        label: '',
                      ).copyWith(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      items: _expenseCategories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an expense category';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description (Optional)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _descriptionController,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputTheme.textAreaDecoration(
                        label: '',
                        hint: 'Enter notes...',
                      ).copyWith(
                        contentPadding: EdgeInsets.all(12.w),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount *',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _amountController,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputTheme.standardDecoration(
                        label: '',
                        hint: 'Enter amount',
                      ).copyWith(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Amount is required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Payment Method
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method *',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<String>(
                      value: _selectedPaymentMethod,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputTheme.dropdownDecoration(
                        label: '',
                      ).copyWith(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      items: _paymentMethods.map((String method) {
                        return DropdownMenuItem<String>(
                          value: method,
                          child: Text(method),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPaymentMethod = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a payment method';
                        }
                        return null;
                      },
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
                            _isEditMode ? 'Update Expense' : 'Save Expense',
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
