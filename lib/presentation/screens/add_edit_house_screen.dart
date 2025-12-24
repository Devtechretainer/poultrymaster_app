import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/house_providers.dart';
import '../../domain/entities/house.dart';
import '../../core/theme/input_theme.dart';

class AddEditHouseScreen extends ConsumerStatefulWidget {
  final House? house;

  const AddEditHouseScreen({super.key, this.house});

  @override
  ConsumerState<AddEditHouseScreen> createState() => _AddEditHouseScreenState();
}

class _AddEditHouseScreenState extends ConsumerState<AddEditHouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _houseNameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _locationController = TextEditingController();

  bool get _isEditMode => widget.house != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final house = widget.house!;
      _houseNameController.text = house.houseName;
      _capacityController.text = house.capacity.toString();
      _locationController.text = house.location;
    }
  }

  @override
  void dispose() {
    _houseNameController.dispose();
    _capacityController.dispose();
    _locationController.dispose();
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

    final houseData = House(
      houseId: widget.house?.houseId ?? 0,
      farmId: farmId,
      userId: userId,
      houseName: _houseNameController.text.trim(),
      capacity: int.parse(_capacityController.text.trim()),
      location: _locationController.text.trim(),
    );

    final controller = ref.read(houseControllerProvider.notifier);
    final success = _isEditMode
        ? await controller.updateHouse(houseData)
        : await controller.createHouse(houseData);

    if (mounted) {
      final message = _isEditMode ? 'House updated' : 'House added';
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$message successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        final error = ref.read(houseControllerProvider).error;
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
    final isLoading = ref.watch(houseControllerProvider).isLoading;
    final title = _isEditMode ? 'Edit House' : 'Add House';

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
                          controller: _houseNameController,
                          decoration: InputTheme.standardDecoration(
                            label: 'House Name *',
                            hint: 'Enter house name',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'House name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _capacityController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Capacity *',
                            hint: 'Enter number',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Capacity is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _locationController,
                          decoration: InputTheme.standardDecoration(
                            label: 'Location *',
                            hint: 'Enter location',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Location is required';
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
