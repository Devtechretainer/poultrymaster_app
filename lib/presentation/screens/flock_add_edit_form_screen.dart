import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import '../widgets/loading_widget.dart';
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
    if (_selectedFlockBatch == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a Flock Batch.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (int.parse(_quantityController.text.trim()) >
        _selectedFlockBatch!.numberOfBirds) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Quantity cannot be greater than available birds in the selected batch.'),
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
        Future.microtask(() {
          if (mounted) {
            setState(() => _selectedFlockBatch = selected);
          }
        });
      }
    }

    if (_isEditMode && _selectedHouse == null && houses.isNotEmpty) {
      final selected = houses
          .firstWhereOrNull((house) => house.houseId == widget.flock!.houseId);
      if (selected != null) {
        Future.microtask(() {
          if (mounted) {
            setState(() => _selectedHouse = selected);
          }
        });
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Flock Name *',
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
                                hint: 'Enter flock name',
                              ).copyWith(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 14.h,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Flock name is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Breed *',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextFormField(
                              controller: _breedController,
                              style: TextStyle(fontSize: 14.sp),
                              decoration: InputTheme.standardDecoration(
                                label: '',
                                hint: 'Enter breed',
                              ).copyWith(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 14.h,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Breed is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantity *',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextFormField(
                              controller: _quantityController,
                              style: TextStyle(fontSize: 14.sp),
                              decoration: InputTheme.standardDecoration(
                                label: '',
                                hint: 'Enter number',
                              ).copyWith(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 14.h,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
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
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date *',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8.h),
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
                                  if (mounted) {
                                    setState(() {
                                      _selectedStartDate = picked;
                                    });
                                  }
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
                                    if (_selectedStartDate == null) {
                                      return 'Start Date is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
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
                        SizedBox(height: 12.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assign to House',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            CustomDropdownButtonFormField<House>(
                              value: _selectedHouse,
                              decoration: InputTheme.dropdownDecoration(
                                label: '',
                              ).copyWith(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 14.h,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
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
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assign to Flock Batch *',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            CustomDropdownButtonFormField<MainFlockBatch>(
                              value: _selectedFlockBatch,
                              decoration: InputTheme.dropdownDecoration(
                                label: '',
                              ).copyWith(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 14.h,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
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
                          ],
                        ),
                        SizedBox(height: 12.h),
                        if (_showInactivationFields) ...[
                          SizedBox(height: 12.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Inactivation Reason (Optional)',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _inactivationReasonController,
                                style: TextStyle(fontSize: 14.sp),
                                decoration: InputTheme.textAreaDecoration(
                                  label: '',
                                  hint: 'Enter reason...',
                                ).copyWith(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 14.h,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Other Reason (Optional)',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _otherReasonController,
                                style: TextStyle(fontSize: 14.sp),
                                decoration: InputTheme.textAreaDecoration(
                                  label: '',
                                  hint: 'Enter reason...',
                                ).copyWith(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 14.h,
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 12.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notes (Optional)',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextFormField(
                              controller: _notesController,
                              style: TextStyle(fontSize: 14.sp),
                              decoration: InputTheme.textAreaDecoration(
                                label: '',
                                hint: 'Enter notes...',
                              ).copyWith(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 14.h,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                              ),
                              maxLines: 3,
                            ),
                          ],
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
