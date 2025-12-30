import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
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
      setState(() {
        _selectedExpenseDate = picked;
      });
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
        Future.microtask(() => setState(() => _selectedFlock = selected));
      }
    }

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
                        CustomDropdownButtonFormField<Flock>(
                          value: _selectedFlock,
                          decoration: InputTheme.dropdownDecoration(
                            label: 'Flock *',
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
                        const SizedBox(height: 16),
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
                              decoration: InputTheme.dateDecoration(
                                label: 'Expense Date *',
                                hint: 'DD/MM/YYYY',
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
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: InputTheme.dropdownDecoration(
                            label: 'Category *',
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
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _amountController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Amount *',
                            hint: 'Enter amount',
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
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedPaymentMethod,
                          decoration: InputTheme.dropdownDecoration(
                            label: 'Payment Method *',
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
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputTheme.textAreaDecoration(
                            label: 'Description (Optional)',
                            hint: 'Enter notes...',
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submitForm,
                            style: FormButtonStyle.primary(),
                            child: isLoading
                                ? const SizedBox(
                                    child: LoadingWidget.small(),
                                  )
                                : const Text(
                                    'Save Record',
                                    style: TextStyle(
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
