import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/feed_usage_providers.dart';
import '../../domain/entities/feed_usage.dart';
import '../../application/providers/flock_providers.dart';
import '../../domain/entities/flock.dart';
import '../widgets/custom_dropdown_button_form_field.dart';
import '../widgets/loading_widget.dart';
import '../../core/theme/input_theme.dart';

class AddEditFeedUsageScreen extends ConsumerStatefulWidget {
  final FeedUsage? feedUsage;

  const AddEditFeedUsageScreen({super.key, this.feedUsage});

  @override
  ConsumerState<AddEditFeedUsageScreen> createState() =>
      _AddEditFeedUsageScreenState();
}

class _AddEditFeedUsageScreenState
    extends ConsumerState<AddEditFeedUsageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityKgController = TextEditingController();
  DateTime? _selectedUsageDate;
  Flock? _selectedFlock;
  String? _selectedFeedType;

  final List<String> _feedTypes = [
    'Starter Feed',
    'Grower Feed',
    'Layer Feed',
    'Broiler Feed',
    'Organic Feed',
    'Custom Mix'
  ];

  bool get _isEditMode => widget.feedUsage != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final usage = widget.feedUsage!;
      _quantityKgController.text = usage.quantityKg.toString();
      _selectedUsageDate = usage.usageDate;
      _selectedFeedType = usage.feedType;
    }
  }

  @override
  void dispose() {
    _quantityKgController.dispose();
    super.dispose();
  }

  Future<void> _selectUsageDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedUsageDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedUsageDate) {
      setState(() {
        _selectedUsageDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedUsageDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usage Date is required.'),
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

    if (_selectedFeedType == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Feed Type is required.'),
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

    final feedUsageData = FeedUsage(
      feedUsageId: widget.feedUsage?.feedUsageId ?? 0,
      farmId: farmId,
      userId: userId,
      flockId: _selectedFlock!.flockId,
      usageDate: _selectedUsageDate!,
      feedType: _selectedFeedType!,
      quantityKg: double.parse(_quantityKgController.text.trim()),
    );

    final controller = ref.read(feedUsageControllerProvider.notifier);
    final success = _isEditMode
        ? await controller.updateFeedUsage(feedUsageData)
        : await controller.createFeedUsage(feedUsageData);

    if (mounted) {
      final message = _isEditMode ? 'Feed Usage updated' : 'Feed Usage added';
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$message successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        final error = ref.read(feedUsageControllerProvider).error;
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
    final isLoading = ref.watch(feedUsageControllerProvider).isLoading;
    final title = _isEditMode ? 'Edit Feed Usage' : 'Add Feed Usage';

    final flockState = ref.watch(flockControllerProvider);
    final flocks = flockState.flocks;
    final flocksLoading = flockState.isLoading;

    if (_isEditMode && _selectedFlock == null && flocks.isNotEmpty) {
      final selected = flocks
          .firstWhereOrNull((flock) => flock.flockId == widget.feedUsage!.flockId);
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
                          onTap: () => _selectUsageDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: _selectedUsageDate == null
                                    ? ''
                                    : '${_selectedUsageDate!.toLocal()}'
                                        .split(' ')[0],
                              ),
                              decoration: InputTheme.dateDecoration(
                                label: 'Usage Date *',
                                hint: 'DD/MM/YYYY',
                              ),
                              validator: (value) {
                                if (_selectedUsageDate == null) {
                                  return 'Usage Date is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedFeedType,
                          decoration: InputTheme.dropdownDecoration(
                            label: 'Feed Type *',
                          ),
                          items: _feedTypes.map((String feedType) {
                            return DropdownMenuItem<String>(
                              value: feedType,
                              child: Text(feedType),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFeedType = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a feed type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _quantityKgController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Quantity (Kg) *',
                            hint: 'Enter amount',
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Quantity (Kg) is required';
                            }
                            if (double.tryParse(value) == null) {
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
