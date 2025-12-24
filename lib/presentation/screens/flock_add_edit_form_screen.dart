import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/flock_providers.dart';
import '../../application/providers/house_providers.dart';
import '../../domain/entities/flock.dart';
import '../../domain/entities/flock_request.dart';
import '../../application/providers/main_flock_batch_providers.dart';
import '../../domain/entities/main_flock_batch.dart';
import '../../domain/entities/house.dart';
import '../widgets/custom_dropdown_button_form_field.dart';
import '../../core/theme/input_theme.dart';

class FlockAddEditFormScreen extends ConsumerStatefulWidget {
  final Flock? flock;

  const FlockAddEditFormScreen({super.key, this.flock});

  @override
  ConsumerState<FlockAddEditFormScreen> createState() =>
      _FlockAddEditFormScreenState();
}

class _FlockAddEditFormScreenState
    extends ConsumerState<FlockAddEditFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _quantityController = TextEditingController();
  final _inactivationReasonController = TextEditingController();
  final _otherReasonController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedStartDate;
  bool _active = true;
  bool _showInactivationFields = false;
  MainFlockBatch? _selectedFlockBatch;
  House? _selectedHouse;

  bool get _isEditMode => widget.flock != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final flock = widget.flock!;
      _nameController.text = flock.name;
      _breedController.text = flock.breed;
      _quantityController.text = flock.quantity.toString();
      _selectedStartDate = flock.startDate;
      _active = flock.active;
      _inactivationReasonController.text = flock.inactivationReason ?? '';
      _otherReasonController.text = flock.otherReason ?? '';
      _notesController.text = flock.notes ?? '';
      _showInactivationFields = !flock.active;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _quantityController.dispose();
    _inactivationReasonController.dispose();
    _otherReasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedStartDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Start Date is required.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedFlockBatch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a Flock Batch.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (int.parse(_quantityController.text.trim()) >
        _selectedFlockBatch!.numberOfBirds) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Quantity cannot be greater than available birds in the selected batch.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authState = ref.read(authControllerProvider);
    final user = authState.user;
    final userId = user?.id ?? '';
    final farmId = user?.farmId ?? user?.id ?? '';

    if (userId.isEmpty || farmId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User information not found. Please login again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final flockRequest = FlockRequest(
      farmId: farmId,
      userId: userId,
      flockId: _isEditMode ? widget.flock!.flockId : 0,
      name: _nameController.text.trim(),
      breed: _breedController.text.trim(),
      startDate: _selectedStartDate!,
      quantity: int.parse(_quantityController.text.trim()),
      active: _active,
      houseId: _selectedHouse?.houseId,
      batchId: _selectedFlockBatch!.batchId,
      batchName: _selectedFlockBatch!.batchName,
      inactivationReason:
          _showInactivationFields ? _inactivationReasonController.text : null,
      otherReason: _showInactivationFields ? _otherReasonController.text : null,
      notes: _notesController.text,
    );
    final controller = ref.read(flockControllerProvider.notifier);
    final success = _isEditMode
        ? await controller.updateFlock(widget.flock!.flockId, flockRequest)
        : await controller.createFlock(flockRequest);

    if (mounted) {
      final message = _isEditMode ? 'Flock updated' : 'Flock added';
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$message successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        final error = ref.read(flockControllerProvider).error;
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
    final isLoading = ref.watch(flockControllerProvider).isLoading;
    final title = _isEditMode ? 'Edit Flock' : 'Add Flock';

    final mainFlockBatchState = ref.watch(mainFlockBatchControllerProvider);
    final flockBatches = mainFlockBatchState.mainFlockBatches;
    final flockBatchesLoading = mainFlockBatchState.isLoading;

    final houseState = ref.watch(houseControllerProvider);
    final houses = houseState.houses;
    final housesLoading = houseState.isLoading;

    if (_isEditMode &&
        _selectedFlockBatch == null &&
        flockBatches.isNotEmpty) {
      final selected = flockBatches
          .firstWhereOrNull((batch) => batch.batchId == widget.flock!.batchId);
      if (selected != null) {
        Future.microtask(() => setState(() => _selectedFlockBatch = selected));
      }
    }

    if (_isEditMode && _selectedHouse == null && houses.isNotEmpty) {
      final selected = houses
          .firstWhereOrNull((house) => house.houseId == widget.flock!.houseId);
      if (selected != null) {
        Future.microtask(() => setState(() => _selectedHouse = selected));
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
                        TextFormField(
                          controller: _nameController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Flock Name *',
                            hint: 'Enter flock name',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Flock name is required';
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
                          controller: _quantityController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Quantity *',
                            hint: 'Enter number',
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
                        GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedStartDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null &&
                                picked != _selectedStartDate) {
                              setState(() {
                                _selectedStartDate = picked;
                              });
                            }
                          },
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
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('Active'),
                            Switch(
                              value: _active,
                              onChanged: (bool value) {
                                setState(() {
                                  _active = value;
                                  _showInactivationFields = !value;
                                  if (value) {
                                    _inactivationReasonController.clear();
                                    _otherReasonController.clear();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomDropdownButtonFormField<House>(
                          value: _selectedHouse,
                          decoration: InputTheme.dropdownDecoration(
                            label: 'Assign to House',
                          ),
                          items: housesLoading
                              ? []
                              : houses.map((House house) {
                                  return DropdownMenuItem<House>(
                                    value: house,
                                    child: Text(house.houseName),
                                  );
                                }).toList(),
                          onChanged: housesLoading
                              ? null
                              : (House? newValue) {
                                  setState(() {
                                    _selectedHouse = newValue;
                                  });
                                },
                          validator: (value) {
                            return null;
                          },
                          isLoading: housesLoading,
                          loadingMessage: 'Loading houses...',
                          emptyMessage: houseState.error != null
                              ? 'Error: ${houseState.error}'
                              : 'No houses found',
                        ),
                        const SizedBox(height: 16),
                        CustomDropdownButtonFormField<MainFlockBatch>(
                          value: _selectedFlockBatch,
                          decoration: InputTheme.dropdownDecoration(
                            label: 'Assign to Flock Batch *',
                          ),
                          items: flockBatchesLoading
                              ? []
                              : flockBatches.map((MainFlockBatch batch) {
                                  return DropdownMenuItem<MainFlockBatch>(
                                    value: batch,
                                    child: Text(batch.batchName),
                                  );
                                }).toList(),
                          onChanged: flockBatchesLoading
                              ? null
                              : (MainFlockBatch? newValue) {
                                  setState(() {
                                    _selectedFlockBatch = newValue;
                                  });
                                },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a Flock Batch';
                            }
                            return null;
                          },
                          isLoading: flockBatchesLoading,
                          loadingMessage: 'Loading batches...',
                          emptyMessage: mainFlockBatchState.error != null
                              ? 'Error: ${mainFlockBatchState.error}'
                              : 'No flock batches found',
                        ),
                        if (_selectedFlockBatch != null)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, left: 12.0),
                            child: Text(
                              'Available in Batch: ${_selectedFlockBatch!.numberOfBirds} birds',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        const SizedBox(height: 16),
                        if (_showInactivationFields) ...[
                          TextFormField(
                            controller: _inactivationReasonController,
                            decoration: InputTheme.textAreaDecoration(
                              label: 'Inactivation Reason (Optional)',
                              hint: 'Enter reason...',
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _otherReasonController,
                            decoration: InputTheme.textAreaDecoration(
                              label: 'Other Reason (Optional)',
                              hint: 'Enter reason...',
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextFormField(
                          controller: _notesController,
                          decoration: InputTheme.textAreaDecoration(
                            label: 'Notes (Optional)',
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
