import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/feed_usage_providers.dart';
import '../../domain/entities/feed_usage.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/unified_list_card_widget.dart';
import '../widgets/ereceipt_detail_widget.dart';
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

  void _showFeedUsageDetail(FeedUsage feedUsage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: EReceiptDetailWidget(
            title: 'Feed Usage Details',
            sections: [
              DetailSection(
                type: DetailSectionType.infoList,
                title: 'Feed Information',
                items: [
                  DetailItem(label: 'Feed Type', value: feedUsage.feedType),
                  DetailItem(label: 'Flock ID', value: '${feedUsage.flockId}'),
                  DetailItem(label: 'Quantity', value: '${feedUsage.quantityKg} Kg'),
                  DetailItem(
                    label: 'Usage Date',
                    value: feedUsage.usageDate.toLocal().toString().split(' ')[0],
                  ),
                ],
              ),
            ],
            actionButtonLabel: 'Edit Feed Usage',
            actionButtonColor: const Color(0xFF2563EB),
            onActionPressed: () {
              Navigator.of(context).pop();
              _navigateToEditFeedUsage(feedUsage);
            },
          ),
        );
      },
    );
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
      showSearchInHeader: true,
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
      padding: EdgeInsets.zero, // End-to-end cards
      itemCount: feedUsages.length,
      itemBuilder: (context, index) {
        final usage = feedUsages[index];
        return UnifiedListCardWidget(
          id: 'FEED-${usage.feedUsageId}',
          title: usage.feedType,
          fields: [
            CardField(label: 'Flock', value: 'Flock ${usage.flockId}'),
            CardField(label: 'Quantity', value: '${usage.quantityKg} Kg'),
            CardField(
              label: 'Date',
              value: usage.usageDate.toLocal().toString().split(' ')[0],
            ),
          ],
          onEdit: () => _navigateToEditFeedUsage(usage),
          onDelete: () => _deleteFeedUsage(usage.feedUsageId),
          onSend: () => _showFeedUsageDetail(usage),
          sendButtonLabel: 'View Details',
        );
      },
    );
  }
}
