import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/production_record_providers.dart';
import '../../domain/entities/production_record.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/info_item_widget.dart';
import '../widgets/loading_widget.dart';
import 'add_edit_production_record_screen.dart';

class ProductionRecordsScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const ProductionRecordsScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<ProductionRecordsScreen> createState() =>
      _ProductionRecordsScreenState();
}

class _ProductionRecordsScreenState
    extends ConsumerState<ProductionRecordsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(productionRecordControllerProvider.notifier)
          .loadProductionRecords();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddProductionRecord() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddEditProductionRecordScreen()),
    );
  }

  void _navigateToEditProductionRecord(ProductionRecord productionRecord) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AddEditProductionRecordScreen(productionRecord: productionRecord),
      ),
    );
  }

  Future<void> _deleteProductionRecord(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Are you sure you want to delete this production record?',
        ),
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
      await ref
          .read(productionRecordControllerProvider.notifier)
          .deleteProductionRecord(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productionRecordState = ref.watch(productionRecordControllerProvider);
    final productionRecords = productionRecordState.productionRecords;
    final isLoading = productionRecordState.isLoading;
    final error = productionRecordState.error;

    return BasePageScreen(
      currentRoute: '/production-records',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Production Records',
      pageSubtitle: 'Track your farm production',
      pageIcon: Icons.description,
      iconBackgroundColor: const Color(0xFFFEF3C7),
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: _navigateToAddProductionRecord,
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Log Production',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _buildContent(productionRecords, isLoading, error),
    );
  }

  Widget _buildContent(
    List<ProductionRecord> productionRecords,
    bool isLoading,
    String? error,
  ) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: LoadingWidget.large(),
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
                  ref
                      .read(productionRecordControllerProvider.notifier)
                      .loadProductionRecords();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (productionRecords.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.description,
        title: 'No production records found',
        subtitle: 'Start tracking your production by logging your first record',
        buttonLabel: 'Log Your First Production',
        onButtonPressed: _navigateToAddProductionRecord,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: productionRecords.length,
      itemBuilder: (context, index) {
        final record = productionRecords[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _ProductionRecordCard(
            record: record,
            index: index + 1,
            onEdit: () => _navigateToEditProductionRecord(record),
            onDelete: () => _deleteProductionRecord(record.id),
          ),
        );
      },
    );
  }
}

/// Production Record Card Widget - Card-based design
class _ProductionRecordCard extends StatelessWidget {
  final ProductionRecord record;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductionRecordCard({
    required this.record,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with number and title
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Flock ${record.flockId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
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
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Info items with icons
            InfoItemWidget(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: record.date.toLocal().toString().split(' ')[0],
            ),
            const SizedBox(height: 12),
            InfoItemWidget(
              icon: Icons.egg_outlined,
              label: 'Production',
              value: '${record.totalProduction} eggs',
            ),
            const SizedBox(height: 12),
            InfoItemWidget(
              icon: Icons.pets_outlined,
              label: 'Mortality',
              value: '${record.mortality} birds',
            ),
            const SizedBox(height: 12),
            InfoItemWidget(
              icon: Icons.inventory_2_outlined,
              label: 'Feed',
              value: '${record.feedKg} Kg',
            ),
            const SizedBox(height: 12),
            InfoItemWidget(
              icon: Icons.numbers_outlined,
              label: 'Birds Left',
              value: '${record.noOfBirdsLeft}',
            ),
            const SizedBox(height: 16),
            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.grey[800],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
