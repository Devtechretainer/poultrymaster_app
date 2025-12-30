import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/feed_usage_providers.dart';
import '../../domain/entities/feed_usage.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/info_item_widget.dart';
import '../widgets/loading_widget.dart';
import 'add_edit_feed_usage_screen.dart';

class FeedUsageScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const FeedUsageScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<FeedUsageScreen> createState() => _FeedUsageScreenState();
}

class _FeedUsageScreenState extends ConsumerState<FeedUsageScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedUsageControllerProvider.notifier).loadFeedUsages();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddFeedUsage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddEditFeedUsageScreen()));
  }

  void _navigateToEditFeedUsage(FeedUsage feedUsage) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEditFeedUsageScreen(feedUsage: feedUsage),
      ),
    );
  }

  Future<void> _deleteFeedUsage(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Are you sure you want to delete this feed usage record?',
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
      await ref.read(feedUsageControllerProvider.notifier).deleteFeedUsage(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedUsageState = ref.watch(feedUsageControllerProvider);
    final feedUsages = feedUsageState.feedUsages;
    final isLoading = feedUsageState.isLoading;
    final error = feedUsageState.error;

    return BasePageScreen(
      currentRoute: '/feed-usage',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Feed Usage',
      pageSubtitle: 'Track feed consumption',
      pageIcon: Icons.inventory,
      iconBackgroundColor: const Color(0xFFF0F9FF),
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: _navigateToAddFeedUsage,
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Record Usage',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _buildContent(feedUsages, isLoading, error),
    );
  }

  Widget _buildContent(
    List<FeedUsage> feedUsages,
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
                      .read(feedUsageControllerProvider.notifier)
                      .loadFeedUsages();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (feedUsages.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.inventory,
        title: 'No feed usage records found',
        subtitle: 'Start tracking feed consumption by adding your first record',
        buttonLabel: 'Record Your First Usage',
        onButtonPressed: _navigateToAddFeedUsage,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: feedUsages.length,
      itemBuilder: (context, index) {
        final usage = feedUsages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _FeedUsageCard(
            usage: usage,
            index: index + 1,
            onEdit: () => _navigateToEditFeedUsage(usage),
            onDelete: () => _deleteFeedUsage(usage.feedUsageId),
          ),
        );
      },
    );
  }
}

/// Feed Usage Card Widget - Card-based design
class _FeedUsageCard extends StatelessWidget {
  final FeedUsage usage;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FeedUsageCard({
    required this.usage,
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
                    usage.feedType,
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
              icon: Icons.pets_outlined,
              label: 'Flock',
              value: 'Flock ${usage.flockId}',
            ),
            const SizedBox(height: 12),
            InfoItemWidget(
              icon: Icons.scale_outlined,
              label: 'Quantity',
              value: '${usage.quantityKg} Kg',
            ),
            const SizedBox(height: 12),
            InfoItemWidget(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: usage.usageDate.toLocal().toString().split(' ')[0],
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
