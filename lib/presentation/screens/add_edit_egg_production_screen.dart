import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/egg_production_providers.dart';
import '../../domain/entities/egg_production.dart';
import '../../application/providers/flock_providers.dart';
import '../../domain/entities/flock.dart';
import '../widgets/custom_dropdown_button_form_field.dart';
import '../widgets/loading_widget.dart';
import '../../core/theme/input_theme.dart';

class AddEditEggProductionScreen extends ConsumerStatefulWidget {
  final EggProduction? eggProduction;

  const AddEditEggProductionScreen({super.key, this.eggProduction});

  @override
  ConsumerState<AddEditEggProductionScreen> createState() =>
      _AddEditEggProductionScreenState();
}

class _AddEditEggProductionScreenState
    extends ConsumerState<AddEditEggProductionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eggCountController = TextEditingController();
  final _production9AMController = TextEditingController();
  final _production12PMController = TextEditingController();
  final _production4PMController = TextEditingController();
  final _brokenEggsController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _selectedProductionDate;
  Flock? _selectedFlock;

  bool get _isEditMode => widget.eggProduction != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final record = widget.eggProduction!;
      _eggCountController.text = record.eggCount.toString();
      _production9AMController.text = record.production9AM.toString();
      _production12PMController.text = record.production12PM.toString();
      _production4PMController.text = record.production4PM.toString();
      _brokenEggsController.text = record.brokenEggs.toString();
      _notesController.text = record.notes ?? '';
      _selectedProductionDate = record.productionDate;
    }

    // Add listeners to update the egg count automatically
    _production9AMController.addListener(_calculateEggCount);
    _production12PMController.addListener(_calculateEggCount);
    _production4PMController.addListener(_calculateEggCount);
    _brokenEggsController.addListener(_calculateEggCount);

    // Initial calculation for edit mode
    if (_isEditMode) {
      _calculateEggCount();
    }
  }

  @override
  void dispose() {
    _eggCountController.dispose();
    _production9AMController.removeListener(_calculateEggCount);
    _production12PMController.removeListener(_calculateEggCount);
    _production4PMController.removeListener(_calculateEggCount);
    _brokenEggsController.removeListener(_calculateEggCount);
    _production9AMController.dispose();
    _production12PMController.dispose();
    _production4PMController.dispose();
    _brokenEggsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _calculateEggCount() {
    final production9AM = int.tryParse(_production9AMController.text) ?? 0;
    final production12PM = int.tryParse(_production12PMController.text) ?? 0;
    final production4PM = int.tryParse(_production4PMController.text) ?? 0;
    final brokenEggs = int.tryParse(_brokenEggsController.text) ?? 0;
    final total = production9AM + production12PM + production4PM + brokenEggs;

    if (_eggCountController.text != total.toString()) {
      _eggCountController.text = total.toString();
    }
  }

  Future<void> _selectProductionDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedProductionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedProductionDate) {
      setState(() {
        _selectedProductionDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedProductionDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Production Date is required.'),
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

    final eggProductionData = EggProduction(
      productionId: widget.eggProduction?.productionId ?? 0,
      farmId: farmId,
      userId: userId,
      flockId: _selectedFlock!.flockId,
      productionDate: _selectedProductionDate!,
      eggCount: int.parse(_eggCountController.text.trim()),
      production9AM: int.parse(_production9AMController.text.trim()),
      production12PM: int.parse(_production12PMController.text.trim()),
      production4PM: int.parse(_production4PMController.text.trim()),
      totalProduction: totalProduction,
      brokenEggs: int.parse(_brokenEggsController.text.trim()),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final controller = ref.read(eggProductionControllerProvider.notifier);
    final success = _isEditMode
        ? await controller.updateEggProduction(eggProductionData)
        : await controller.createEggProduction(eggProductionData);

    if (mounted) {
      final message = _isEditMode ? 'Record updated' : 'Record added';
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$message successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        final error = ref.read(eggProductionControllerProvider).error;
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
    final isLoading = ref.watch(eggProductionControllerProvider).isLoading;
    final title = _isEditMode ? 'Edit Egg Production' : 'Add Egg Production';

    final flockState = ref.watch(flockControllerProvider);
    final flocks = flockState.flocks;
    final flocksLoading = flockState.isLoading;

    if (_isEditMode && _selectedFlock == null && flocks.isNotEmpty) {
      final selected = flocks.firstWhereOrNull(
          (flock) => flock.flockId == widget.eggProduction!.flockId);
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
                          onTap: () => _selectProductionDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: _selectedProductionDate == null
                                    ? ''
                                    : '${_selectedProductionDate!.toLocal()}'
                                        .split(' ')[0],
                              ),
                              decoration: InputTheme.dateDecoration(
                                label: 'Production Date *',
                                hint: 'DD/MM/YYYY',
                              ),
                              validator: (value) {
                                if (_selectedProductionDate == null) {
                                  return 'Production Date is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _eggCountController,
                          readOnly: true,
                          decoration: InputTheme.standardDecoration(
                            label: 'Egg Count *',
                            hint: 'Calculated automatically',
                          ),
                          keyboardType: TextInputType.number,
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
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _brokenEggsController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Broken Eggs *',
                            hint: 'Enter number',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Broken Eggs is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
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
