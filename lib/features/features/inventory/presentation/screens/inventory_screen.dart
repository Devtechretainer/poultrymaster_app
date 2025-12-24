import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';

/// Inventory Screen
class InventoryScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const InventoryScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _items = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/inventory',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Inventory',
      pageSubtitle: 'Manage your inventory items',
      pageIcon: Icons.inventory_2,
      iconBackgroundColor: const Color(0xFFE0E7FF), // bg-indigo-100
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Item',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // bg-blue-600
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _items.isEmpty
          ? EmptyStateWidget(
              icon: Icons.inventory_2,
              title: 'No inventory items found',
              subtitle: 'Get started by adding your first inventory item',
              buttonLabel: 'Add Your First Item',
              onButtonPressed: () {},
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Inventory Items List')),
            ),
    );
  }
}
