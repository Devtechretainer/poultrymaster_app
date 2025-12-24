import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/production_record_providers.dart';
import '../../domain/entities/production_record.dart';
import '../../application/providers/flock_providers.dart';
import '../../domain/entities/flock.dart';
import '../widgets/custom_dropdown_button_form_field.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/theme/input_theme.dart';

class AddEditProductionRecordScreen extends ConsumerStatefulWidget {
  final ProductionRecord? productionRecord;

  const AddEditProductionRecordScreen({super.key, this.productionRecord});

  @override
  ConsumerState<AddEditProductionRecordScreen> createState() =>
      _AddEditProductionRecordScreenState();
}

class _AddEditProductionRecordScreenState
    extends ConsumerState<AddEditProductionRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageInWeeksController = TextEditingController();
  final _ageInDaysController = TextEditingController();
  final _noOfBirdsController = TextEditingController();
  final _mortalityController = TextEditingController();
  final _feedKgController = TextEditingController();
  final _medicationController = TextEditingController();
  final _production9AMController = TextEditingController();
  final _production12PMController = TextEditingController();
  final _production4PMController = TextEditingController();
  DateTime? _selectedDate;
  Flock? _selectedFlock;

  bool get _isEditMode => widget.productionRecord != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final record = widget.productionRecord!;
      _ageInWeeksController.text = record.ageInWeeks.toString();
      _ageInDaysController.text = record.ageInDays.toString();
      _noOfBirdsController.text = record.noOfBirds.toString();
      _mortalityController.text = record.mortality.toString();
      _feedKgController.text = record.feedKg.toString();
      _medicationController.text = record.medication ?? '';
      _production9AMController.text = record.production9AM.toString();
      _production12PMController.text = record.production12PM.toString();
      _production4PMController.text = record.production4PM.toString();
      _selectedDate = record.date;
    }

  }

  @override
  void dispose() {
    _ageInWeeksController.dispose();
    _ageInDaysController.dispose();
    _noOfBirdsController.dispose();
    _mortalityController.dispose();
    _feedKgController.dispose();
    _medicationController.dispose();
    _production9AMController.dispose();
    _production12PMController.dispose();
    _production4PMController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Date is required.'),
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

    final totalProduction = int.parse(_production9AMController.text.trim()) +
        int.parse(_production12PMController.text.trim()) +
        int.parse(_production4PMController.text.trim());

    final productionRecordData = ProductionRecord(
      id: widget.productionRecord?.id ?? 0,
      farmId: farmId,
      userId: userId,
      createdBy: user?.username ?? 'Unknown',
      updatedBy: user?.username ?? 'Unknown',
      ageInWeeks: int.parse(_ageInWeeksController.text.trim()),
      ageInDays: int.parse(_ageInDaysController.text.trim()),
      date: _selectedDate!,
      noOfBirds: int.parse(_noOfBirdsController.text.trim()),
      mortality: int.parse(_mortalityController.text.trim()),
      noOfBirdsLeft: int.parse(_noOfBirdsController.text.trim()) -
          int.parse(_mortalityController.text.trim()),
      feedKg: double.parse(_feedKgController.text.trim()),
      medication: _medicationController.text.trim().isEmpty
          ? null
          : _medicationController.text.trim(),
      production9AM: int.parse(_production9AMController.text.trim()),
      production12PM: int.parse(_production12PMController.text.trim()),
      production4PM: int.parse(_production4PMController.text.trim()),
      totalProduction: totalProduction,
      createdAt: widget.productionRecord?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      flockId: _selectedFlock!.flockId,
    );

    final controller = ref.read(productionRecordControllerProvider.notifier);
    final success = _isEditMode
        ? await controller.updateProductionRecord(productionRecordData)
        : await controller.createProductionRecord(productionRecordData);

    if (mounted) {
      final message = _isEditMode ? 'Record updated' : 'Record added';
      if (success) {
        ToastUtils.showSuccess('$message successfully!');
        Navigator.pop(context);
      } else {
        final error = ref.read(productionRecordControllerProvider).error;
        ToastUtils.showError(error ?? 'Failed to $message');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(productionRecordControllerProvider).isLoading;
    final title = _isEditMode ? 'Edit Production Record' : 'Add Production Record';

    final flockState = ref.watch(flockControllerProvider);
    final flocks = flockState.flocks;
    final flocksLoading = flockState.isLoading;

    if (_isEditMode &&
        _selectedFlock == null &&
        flocks.isNotEmpty) {
      final selected = flocks.firstWhereOrNull(
          (flock) => flock.flockId == widget.productionRecord!.flockId);
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
                        TextFormField(
                          controller: _ageInWeeksController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Age in Weeks *',
                            hint: 'Enter number',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Age in Weeks is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _ageInDaysController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Age in Days *',
                            hint: 'Enter number',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Age in Days is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: _selectedDate == null
                                    ? ''
                                    : '${_selectedDate!.toLocal()}'
                                        .split(' ')[0],
                              ),
                              decoration: InputTheme.dateDecoration(
                                label: 'Date *',
                                hint: 'DD/MM/YYYY',
                              ),
                              validator: (value) {
                                if (_selectedDate == null) {
                                  return 'Date is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _noOfBirdsController,
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
                        TextFormField(
                          controller: _mortalityController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Mortality *',
                            hint: 'Enter number',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Mortality is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _feedKgController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Feed (Kg) *',
                            hint: 'Enter amount',
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Feed (Kg) is required';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _medicationController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Medication (Optional)',
                            hint: 'Enter medication',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _production9AMController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Production 9 AM *',
                            hint: 'Enter number',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Production 9 AM is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _production12PMController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Production 12 PM *',
                            hint: 'Enter number',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Production 12 PM is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _production4PMController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Production 4 PM *',
                            hint: 'Enter number',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Production 4 PM is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
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
