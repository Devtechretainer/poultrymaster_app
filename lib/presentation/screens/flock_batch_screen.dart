import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/main_flock_batch_providers.dart';
import '../../domain/entities/main_flock_batch.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/unified_list_card_widget.dart';
import '../widgets/ereceipt_detail_widget.dart';
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
      ref
          .read(mainFlockBatchControllerProvider.notifier)
          .loadMainFlockBatches();
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

  void _showFlockBatchDetail(MainFlockBatch batch) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: EReceiptDetailWidget(
            title: 'Flock Batch Details',
            sections: [
              DetailSection(
                type: DetailSectionType.infoList,
                title: 'Batch Information',
                items: [
                  DetailItem(label: 'Batch Name', value: batch.batchName),
                  DetailItem(label: 'Batch Code', value: batch.batchCode),
                  DetailItem(label: 'Breed', value: batch.breed),
                  DetailItem(
                    label: 'Number of Birds',
                    value: '${batch.numberOfBirds}',
                  ),
                  DetailItem(
                    label: 'Start Date',
                    value: batch.startDate.toLocal().toString().split(' ')[0],
                  ),
                  DetailItem(
                    label: 'Created Date',
                    value: batch.createdDate.toLocal().toString().split(' ')[0],
                  ),
                ],
              ),
            ],
            actionButtonLabel: 'Edit Batch',
            actionButtonColor: const Color(0xFF2563EB),
            onActionPressed: () {
              Navigator.of(context).pop();
              _navigateToEditMainFlockBatch(batch);
            },
          ),
        );
      },
    );
  }

  void _navigateToEditMainFlockBatch(MainFlockBatch mainFlockBatch) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AddEditMainFlockBatchScreen(mainFlockBatch: mainFlockBatch),
      ),
    );
  }

  Future<void> _deleteMainFlockBatch(int batchId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Are you sure you want to delete this flock batch?',
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
          .read(mainFlockBatchControllerProvider.notifier)
          .deleteMainFlockBatch(batchId);
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
      showSearchInHeader: true,
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

  Widget _buildContent(
    List<MainFlockBatch> mainFlockBatches,
    bool isLoading,
    String? error,
  ) {
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
                  ref
                      .read(mainFlockBatchControllerProvider.notifier)
                      .loadMainFlockBatches();
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
      padding: EdgeInsets.zero, // End-to-end cards
      itemCount: mainFlockBatches.length,
      itemBuilder: (context, index) {
        final batch = mainFlockBatches[index];
        return UnifiedListCardWidget(
          id: 'BATCH-${batch.batchId}',
          title: batch.batchName,
          fields: [
            CardField(label: 'Batch Code', value: batch.batchCode),
            CardField(label: 'Breed', value: batch.breed),
            CardField(label: 'Number of Birds', value: '${batch.numberOfBirds}'),
            CardField(
              label: 'Start Date',
              value: batch.startDate.toLocal().toString().split(' ')[0],
            ),
          ],
          onEdit: () => _navigateToEditMainFlockBatch(batch),
          onDelete: () => _deleteMainFlockBatch(batch.batchId),
          onSend: () => _showFlockBatchDetail(batch),
          sendButtonLabel: 'View Details',
        );
      },
    );
  }
}
