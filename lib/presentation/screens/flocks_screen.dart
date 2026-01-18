import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/flock_providers.dart';
import '../../domain/entities/flock.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/ereceipt_detail_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/unified_list_card_widget.dart';
import '../widgets/asset_image_widget.dart';
import 'flock_add_edit_form_screen.dart';

/// Flocks Screen
class FlocksScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const FlocksScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<FlocksScreen> createState() => _FlocksScreenState();
}

class _FlocksScreenState extends ConsumerState<FlocksScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(flockControllerProvider.notifier).loadFlocks();
    });
  }

  void _navigateToAddFlock() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const FlockAddEditFormScreen()));
  }

  void _showFlockDetail(Flock flock) {
    final ageInDays = DateTime.now().difference(flock.startDate).inDays;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: EReceiptDetailWidget(
            title: 'Flock Details',
            sections: [
              // Item Card Section with Flock Icon
              DetailSection(
                type: DetailSectionType.itemCard,
                title: flock.name,
                subtitle: 'Flock Management',
                footer: 'Breed: ${flock.breed}',
                imageWidget: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: AssetImageWidget(
                    assetPath: 'assets/icons/flock.png',
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              DetailSection(
                type: DetailSectionType.infoList,
                title: 'Flock Information',
                items: [
                  DetailItem(label: 'Name', value: flock.name),
                  DetailItem(label: 'Breed', value: flock.breed),
                  DetailItem(label: 'Quantity', value: '${flock.quantity} birds'),
                  DetailItem(
                    label: 'Start Date',
                    value: flock.startDate.toLocal().toString().split(' ')[0],
                  ),
                  DetailItem(label: 'Age', value: '$ageInDays days'),
                  DetailItem(
                    label: 'Status',
                    value: flock.active ? 'Active' : 'Inactive',
                    valueColor: flock.active ? Colors.green : Colors.orange,
                  ),
                  if (flock.batchName != null)
                    DetailItem(label: 'Batch', value: flock.batchName!),
                  if (flock.houseId != null)
                    DetailItem(label: 'House ID', value: '${flock.houseId}'),
                  if (flock.notes != null && flock.notes!.isNotEmpty)
                    DetailItem(label: 'Notes', value: flock.notes!),
                  if (!flock.active && flock.inactivationReason != null)
                    DetailItem(
                      label: 'Inactivation Reason',
                      value: flock.inactivationReason!,
                    ),
                ],
              ),
            ],
            actionButtonLabel: 'Edit Flock',
            actionButtonColor: const Color(0xFF2563EB),
            onActionPressed: () {
              Navigator.of(context).pop();
              _navigateToEditFlock(flock);
            },
          ),
        );
      },
    );
  }

  void _navigateToEditFlock(Flock flock) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FlockAddEditFormScreen(flock: flock)),
    );
  }

  Future<void> _deleteFlock(int flockId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this flock?'),
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
      await ref.read(flockControllerProvider.notifier).deleteFlock(flockId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final flockState = ref.watch(flockControllerProvider);
    final flocks = flockState.flocks;
    final isLoading = flockState.isLoading;
    final error = flockState.error;

    return BasePageScreen(
      currentRoute: '/flocks',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Flocks',
      pageSubtitle: 'Manage your bird flocks',
      pageIconAsset: 'assets/icons/flock.png',
      iconBackgroundColor: const Color(0xFFECFDF5),
      searchController: _searchController,
      showSearchInHeader: true, // Show search in page header
      actionButton: ElevatedButton.icon(
        onPressed: _navigateToAddFlock,
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Flock',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _buildContent(flocks, isLoading, error),
    );
  }

  Widget _buildContent(List<Flock> flocks, bool isLoading, String? error) {
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
                  ref.read(flockControllerProvider.notifier).loadFlocks();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (flocks.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.eco,
        title: 'No flocks found',
        subtitle: 'Get started by adding your first flock',
        buttonLabel: 'Add Your First Flock',
        onButtonPressed: _navigateToAddFlock,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero, // No padding for end-to-end cards
      itemCount: flocks.length,
      itemBuilder: (context, index) {
        final flock = flocks[index];
        final ageInDays = DateTime.now().difference(flock.startDate).inDays;
        final fields = <CardField>[
          CardField(label: 'Breed', value: flock.breed),
          CardField(label: 'Quantity', value: '${flock.quantity} birds'),
          CardField(label: 'Age', value: '$ageInDays days'),
        ];
        if (flock.batchName != null) {
          fields.add(CardField(label: 'Batch', value: flock.batchName!));
        }
        
        return UnifiedListCardWidget(
          id: 'FLOCK-${flock.flockId}',
          title: flock.name,
          fields: fields,
          status: flock.active ? 'Active' : 'Inactive',
          statusColor: flock.active ? Colors.green : Colors.orange,
          onEdit: () => _navigateToEditFlock(flock),
          onDelete: () => _deleteFlock(flock.flockId),
          onSend: () => _showFlockDetail(flock),
          sendButtonLabel: 'View Details',
        );
      },
    );
  }
}
