import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/house_providers.dart';
import '../../domain/entities/house.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/info_item_widget.dart';
import '../widgets/loading_widget.dart';
import 'add_edit_house_screen.dart';

class HousesScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const HousesScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<HousesScreen> createState() => _HousesScreenState();
}

class _HousesScreenState extends ConsumerState<HousesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(houseControllerProvider.notifier).loadHouses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddHouse() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddEditHouseScreen()),
    );
  }

  void _showHouseDetail(House house) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'House Details',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  InfoItemWidget(
                    icon: Icons.home_outlined,
                    label: 'House Name',
                    value: house.houseName,
                  ),
                  const SizedBox(height: 16),
                  InfoItemWidget(
                    icon: Icons.numbers_outlined,
                    label: 'Capacity',
                    value: '${house.capacity}',
                  ),
                  const SizedBox(height: 16),
                  InfoItemWidget(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: house.location,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToEditHouse(house);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Edit House'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToEditHouse(House house) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddEditHouseScreen(house: house)),
    );
  }

  Future<void> _deleteHouse(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this house?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(houseControllerProvider.notifier).deleteHouse(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final houseState = ref.watch(houseControllerProvider);
    final houses = houseState.houses;
    final isLoading = houseState.isLoading;
    final error = houseState.error;

    return BasePageScreen(
      currentRoute: '/houses',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Houses',
      pageSubtitle: 'Manage your poultry houses',
      pageIcon: Icons.home_work,
      iconBackgroundColor: const Color(0xFFECFDF5),
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: _navigateToAddHouse,
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add House',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _buildContent(houses, isLoading, error),
    );
  }

  Widget _buildContent(List<House> houses, bool isLoading, String? error) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: LoadingWidget.large(),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(houseControllerProvider.notifier).loadHouses();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (houses.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.home_work,
        title: 'No houses found',
        subtitle: 'Start managing houses by adding your first poultry house',
        buttonLabel: 'Add Your First House',
        onButtonPressed: _navigateToAddHouse,
      );
    }

    return Card(
      child: ListView.builder(
        itemCount: houses.length,
        itemBuilder: (context, index) {
          final house = houses[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Text(
                house.houseName.isNotEmpty ? house.houseName[0].toUpperCase() : 'H',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              'House Name: ${house.houseName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Capacity: ${house.capacity}'),
                Text('Location: ${house.location}'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'view') {
                  _showHouseDetail(house);
                } else if (value == 'edit') {
                  _navigateToEditHouse(house);
                } else if (value == 'delete') {
                  _deleteHouse(house.houseId);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 18),
                      SizedBox(width: 8),
                      Text('View Details'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              _showHouseDetail(house);
            },
          );
        },
      ),
    );
  }
}