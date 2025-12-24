import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/main_flock_batch_providers.dart';
import '../../domain/entities/main_flock_batch.dart';
import '../../domain/entities/flock_batch_request.dart';
import '../../core/theme/input_theme.dart';

class AddEditMainFlockBatchScreen extends ConsumerStatefulWidget {
  final MainFlockBatch? mainFlockBatch;

  const AddEditMainFlockBatchScreen({super.key, this.mainFlockBatch});

  @override
  ConsumerState<AddEditMainFlockBatchScreen> createState() =>
      _AddEditMainFlockBatchScreenState();
}

class _AddEditMainFlockBatchScreenState
    extends ConsumerState<AddEditMainFlockBatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _batchCodeController = TextEditingController();
  final _batchNameController = TextEditingController();
  final _breedController = TextEditingController();
  final _numberOfBirdsController = TextEditingController();
  DateTime? _selectedStartDate;

  bool get _isEditMode => widget.mainFlockBatch != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final batch = widget.mainFlockBatch!;
      _batchCodeController.text = batch.batchCode;
      _batchNameController.text = batch.batchName;
      _breedController.text = batch.breed;
      _numberOfBirdsController.text = batch.numberOfBirds.toString();
      _selectedStartDate = batch.startDate;
    }
  }

  @override
  void dispose() {
    _batchCodeController.dispose();
    _batchNameController.dispose();
    _breedController.dispose();
    _numberOfBirdsController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedStartDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Start Date is required.'),
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

    final flockBatchRequest = FlockBatchRequest(
      farmId: farmId,
      userId: userId,
      batchCode: _batchCodeController.text.trim(),
      batchName: _batchNameController.text.trim(),
      breed: _breedController.text.trim(),
      numberOfBirds: int.parse(_numberOfBirdsController.text.trim()),
      startDate: _selectedStartDate!,
    );

    final controller = ref.read(mainFlockBatchControllerProvider.notifier);
    final success = _isEditMode
        ? await controller.updateMainFlockBatch(widget.mainFlockBatch!.batchId, flockBatchRequest)
        : await controller.createMainFlockBatch(flockBatchRequest);

    if (mounted) {
      final message = _isEditMode ? 'Batch updated' : 'Batch added';
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$message successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        final error = ref.read(mainFlockBatchControllerProvider).error;
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
    final isLoading = ref.watch(mainFlockBatchControllerProvider).isLoading;
    final title = _isEditMode ? 'Edit Main Flock Batch' : 'Add Main Flock Batch';

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
                        TextFormField(
                          controller: _batchCodeController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Batch Code *',
                            hint: 'Enter batch code',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Batch Code is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _batchNameController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Batch Name *',
                            hint: 'Enter batch name',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Batch Name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _breedController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Breed *',
                            hint: 'Enter breed',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Breed is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _numberOfBirdsController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Number of Birds *',
                            hint: 'Enter number',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Number of Birds is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _selectStartDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: _selectedStartDate == null
                                    ? ''
                                    : '${_selectedStartDate!.toLocal()}'
                                        .split(' ')[0],
                              ),
                              decoration: InputTheme.dateDecoration(
                                label: 'Start Date *',
                                hint: 'DD/MM/YYYY',
                              ),
                              validator: (value) {
                                if (_selectedStartDate == null) {
                                  return 'Start Date is required';
                                }
                                return null;
                              },
                            ),
                          ),
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
