import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/house_providers.dart';
import '../../domain/entities/house.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/unified_list_card_widget.dart';
import '../widgets/ereceipt_detail_widget.dart';
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
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: EReceiptDetailWidget(
            title: 'House Details',
            sections: [
              DetailSection(
                type: DetailSectionType.infoList,
                title: 'House Information',
                items: [
                  DetailItem(label: 'House Name', value: house.houseName),
                  DetailItem(label: 'Capacity', value: '${house.capacity}'),
                  DetailItem(label: 'Location', value: house.location),
                ],
              ),
            ],
            actionButtonLabel: 'Edit House',
            actionButtonColor: const Color(0xFF2563EB),
            onActionPressed: () {
              Navigator.of(context).pop();
              _navigateToEditHouse(house);
            },
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
      showSearchInHeader: true,
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

    return ListView.builder(
      padding: EdgeInsets.zero, // End-to-end cards
      itemCount: houses.length,
      itemBuilder: (context, index) {
        final house = houses[index];
        return UnifiedListCardWidget(
          id: 'HOUSE-${house.houseId}',
          title: house.houseName,
          fields: [
            CardField(label: 'Capacity', value: '${house.capacity}'),
            CardField(label: 'Location', value: house.location),
          ],
          onEdit: () => _navigateToEditHouse(house),
          onDelete: () => _deleteHouse(house.houseId),
          onSend: () => _showHouseDetail(house),
          sendButtonLabel: 'View Details',
        );
      },
    );
  }
}