import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/sale_providers.dart';
import '../../domain/entities/sale.dart';
import '../../application/providers/flock_providers.dart';
import '../../domain/entities/flock.dart';
import '../../application/providers/customer_providers.dart';
import '../../domain/entities/customer.dart';
import '../widgets/custom_dropdown_button_form_field.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/theme/input_theme.dart';

class AddEditSaleScreen extends ConsumerStatefulWidget {
  final Sale? sale;

  const AddEditSaleScreen({super.key, this.sale});

  @override
  ConsumerState<AddEditSaleScreen> createState() => _AddEditSaleScreenState();
}

class _AddEditSaleScreenState extends ConsumerState<AddEditSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _saleDescriptionController = TextEditingController();
  DateTime? _selectedSaleDate;
  Flock? _selectedFlock;
  Customer? _selectedCustomer;
  String? _selectedPaymentMethod;
  double _totalAmount = 0.0;

  final List<String> _paymentMethods = [
    'Cash',
    'Credit card',
    'Bank Transfer',
    'Check',
  ];

  bool get _isEditMode => widget.sale != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final sale = widget.sale!;
      _productController.text = sale.product;
      _quantityController.text = sale.quantity.toString();
      _unitPriceController.text = sale.unitPrice.toString();
      _selectedPaymentMethod = sale.paymentMethod;
      _saleDescriptionController.text = sale.saleDescription ?? '';
      _selectedSaleDate = sale.saleDate;
      _totalAmount = sale.totalAmount;
    }

    _quantityController.addListener(_calculateTotalAmount);
    _unitPriceController.addListener(_calculateTotalAmount);
  }

  @override
  void dispose() {
    _productController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _saleDescriptionController.dispose();
    super.dispose();
  }

  void _calculateTotalAmount() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0.0;
    setState(() {
      _totalAmount = quantity * unitPrice;
    });
  }

  Future<void> _selectSaleDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedSaleDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedSaleDate) {
      setState(() {
        _selectedSaleDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSaleDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sale Date is required.'),
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

    if (_selectedCustomer == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Customer is required.'),
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

    final saleData = Sale(
      saleId: widget.sale?.saleId ?? 0,
      farmId: farmId,
      userId: userId,
      saleDate: _selectedSaleDate!,
      product: _productController.text.trim(),
      quantity: int.parse(_quantityController.text.trim()),
      unitPrice: double.parse(_unitPriceController.text.trim()),
      totalAmount: _totalAmount,
      paymentMethod: _selectedPaymentMethod!,
      customerName: _selectedCustomer!.name,
      flockId: _selectedFlock!.flockId,
      saleDescription: _saleDescriptionController.text.trim().isEmpty
          ? null
          : _saleDescriptionController.text.trim(),
      createdDate: widget.sale?.createdDate ?? DateTime.now(),
    );

    final controller = ref.read(saleControllerProvider.notifier);
    final success = _isEditMode
        ? await controller.updateSale(saleData)
        : await controller.createSale(saleData);

    if (mounted) {
      final message = _isEditMode ? 'Sale updated' : 'Sale added';
      if (success) {
        ToastUtils.showSuccess('$message successfully!');
        Navigator.pop(context);
      } else {
        final error = ref.read(saleControllerProvider).error;
        ToastUtils.showError(error ?? 'Failed to $message');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(saleControllerProvider).isLoading;
    final title = _isEditMode ? 'Edit Sale' : 'Add Sale';

    final flockState = ref.watch(flockControllerProvider);
    final flocks = flockState.flocks;
    final flocksLoading = flockState.isLoading;

    final customerState = ref.watch(customerControllerProvider);
    final customers = customerState.customers;
    final customersLoading = customerState.isLoading;

    if (_isEditMode && _selectedFlock == null && flocks.isNotEmpty) {
      final selected = flocks.firstWhereOrNull(
        (flock) => flock.flockId == widget.sale!.flockId,
      );
      if (selected != null) {
        Future.microtask(() => setState(() => _selectedFlock = selected));
      }
    }

    if (_isEditMode && _selectedCustomer == null && customers.isNotEmpty) {
      final selected = customers.firstWhereOrNull(
        (customer) => customer.name == widget.sale!.customerName,
      );
      if (selected != null) {
        Future.microtask(() => setState(() => _selectedCustomer = selected));
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
                          onTap: () => _selectSaleDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: _selectedSaleDate == null
                                    ? ''
                                    : '${_selectedSaleDate!.toLocal()}'.split(
                                        ' ',
                                      )[0],
                              ),
                              decoration: InputTheme.dateDecoration(
                                label: 'Sale Date *',
                                hint: 'DD/MM/YYYY',
                              ),
                              validator: (value) {
                                if (_selectedSaleDate == null) {
                                  return 'Sale Date is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _productController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Product *',
                            hint: 'Enter product name',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Product is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _quantityController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Quantity *',
                            hint: 'Enter quantity',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Quantity is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _unitPriceController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Unit Price *',
                            hint: 'Enter unit price',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Unit Price is required';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Total Amount: ${_totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                        CustomDropdownButtonFormField<Customer>(
                          value: _selectedCustomer,
                          decoration: InputTheme.dropdownDecoration(
                            label: 'Customer *',
                          ),
                          items: customersLoading
                              ? []
                              : customers.map((Customer customer) {
                                  return DropdownMenuItem<Customer>(
                                    value: customer,
                                    child: Text(customer.name),
                                  );
                                }).toList(),
                          onChanged: customersLoading
                              ? null
                              : (Customer? newValue) {
                                  setState(() {
                                    _selectedCustomer = newValue;
                                  });
                                },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a customer';
                            }
                            return null;
                          },
                          isLoading: customersLoading,
                          loadingMessage: 'Loading customers...',
                          emptyMessage: customerState.error != null
                              ? 'Error: ${customerState.error}'
                              : 'No customers found. Please add a customer first.',
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _saleDescriptionController,
                          decoration: InputTheme.textAreaDecoration(
                            label: 'Sale Description (Optional)',
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
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
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
