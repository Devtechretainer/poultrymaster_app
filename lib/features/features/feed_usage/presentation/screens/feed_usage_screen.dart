import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';

/// Feed Usage Screen
class FeedUsageScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const FeedUsageScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<FeedUsageScreen> createState() => _FeedUsageScreenState();
}

class _FeedUsageScreenState extends State<FeedUsageScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _records = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/feed-usage',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Feed Usage',
      pageSubtitle: 'Track feed consumption and usage',
      pageIcon: Icons.inventory,
      iconBackgroundColor: const Color(0xFFF3F4F6), // bg-slate-100
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Record',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // bg-blue-600
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _records.isEmpty
          ? EmptyStateWidget(
              icon: Icons.inventory,
              title: 'No feed usage records found',
              subtitle: 'Get started by adding your first feed usage record',
              buttonLabel: 'Add Your First Record',
              onButtonPressed: () {},
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Feed Usage Records List')),
            ),
    );
  }
}
