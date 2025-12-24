import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';

/// Resources Screen
class ResourcesScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const ResourcesScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _resources = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/resources',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Resources',
      pageSubtitle: 'Manage your farm resources and documents',
      pageIcon: Icons.book,
      iconBackgroundColor: const Color(0xFFF3E8FF), // bg-purple-100
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Resource',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // bg-blue-600
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _resources.isEmpty
          ? EmptyStateWidget(
              icon: Icons.book,
              title: 'No resources found',
              subtitle: 'Get started by adding your first resource',
              buttonLabel: 'Add Your First Resource',
              onButtonPressed: () {},
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Resources List')),
            ),
    );
  }
}
