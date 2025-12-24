import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';

/// Flock Batch Screen
class FlockBatchScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const FlockBatchScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<FlockBatchScreen> createState() => _FlockBatchScreenState();
}

class _FlockBatchScreenState extends State<FlockBatchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _batches = []; // Empty for now

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/flock-batch',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Flock Batch',
      pageSubtitle: 'Manage your flock batches',
      pageIcon: Icons.eco,
      iconBackgroundColor: const Color(0xFFD1FAE5), // bg-green-100
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {},
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
      child: _batches.isEmpty
          ? EmptyStateWidget(
              icon: Icons.eco,
              title: 'No flock batches found',
              subtitle: 'Get started by adding your first flock batch',
              buttonLabel: 'Add Your First Batch',
              onButtonPressed: () {},
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Flock Batch List')),
            ),
    );
  }
}
