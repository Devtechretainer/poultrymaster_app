import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/main_flock_batch_providers.dart';
import '../../domain/entities/main_flock_batch.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/info_item_widget.dart';
import 'add_edit_main_flock_batch_screen.dart';

class FlockBatchScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const FlockBatchScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<FlockBatchScreen> createState() => _FlockBatchScreenState();
}

class _FlockBatchScreenState extends ConsumerState<FlockBatchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mainFlockBatchControllerProvider.notifier).loadMainFlockBatches();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddMainFlockBatch() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddEditMainFlockBatchScreen()),
    );
  }

  void _navigateToEditMainFlockBatch(MainFlockBatch mainFlockBatch) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) =>
              AddEditMainFlockBatchScreen(mainFlockBatch: mainFlockBatch)),
    );
  }

  Future<void> _deleteMainFlockBatch(int batchId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this flock batch?'),
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
      await ref.read(mainFlockBatchControllerProvider.notifier).deleteMainFlockBatch(batchId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainFlockBatchState = ref.watch(mainFlockBatchControllerProvider);
    final mainFlockBatches = mainFlockBatchState.mainFlockBatches;
    final isLoading = mainFlockBatchState.isLoading;
    final error = mainFlockBatchState.error;

    return BasePageScreen(
      currentRoute: '/flock-batch',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Flock Batches',
      pageSubtitle: 'Manage your main flock batches',
      pageIcon: Icons.grass,
      iconBackgroundColor: const Color(0xFFE0F7FA), // Light Cyan
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: _navigateToAddMainFlockBatch,
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Batch',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // bg-blue-600
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _buildContent(mainFlockBatches, isLoading, error),
    );
  }

  Widget _buildContent(List<MainFlockBatch> mainFlockBatches, bool isLoading, String? error) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
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
                  ref.read(mainFlockBatchControllerProvider.notifier).loadMainFlockBatches();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (mainFlockBatches.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.grass,
        title: 'No flock batches found',
        subtitle: 'Get started by adding your first flock batch',
        buttonLabel: 'Add Your First Batch',
        onButtonPressed: _navigateToAddMainFlockBatch,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mainFlockBatches.length,
      itemBuilder: (context, index) {
        final batch = mainFlockBatches[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _FlockBatchCard(
            batch: batch,
            index: index + 1,
            onEdit: () => _navigateToEditMainFlockBatch(batch),
            onDelete: () => _deleteMainFlockBatch(batch.batchId),
          ),
        );
      },
    );
  }
}

/// Flock Batch Card Widget - Card-based design
class _FlockBatchCard extends StatelessWidget {
  final MainFlockBatch batch;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FlockBatchCard({
    required this.batch,
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
                    batch.batchName,
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
              icon: Icons.qr_code_outlined,
              label: 'Batch Code',
              value: batch.batchCode,
            ),
            const SizedBox(height: 12),
            InfoItemWidget(
              icon: Icons.category_outlined,
              label: 'Breed',
              value: batch.breed,
            ),
            const SizedBox(height: 12),
            InfoItemWidget(
              icon: Icons.numbers_outlined,
              label: 'Number of Birds',
              value: '${batch.numberOfBirds}',
            ),
            const SizedBox(height: 12),
            InfoItemWidget(
              icon: Icons.calendar_today_outlined,
              label: 'Start Date',
              value: batch.startDate.toLocal().toString().split(' ')[0],
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
