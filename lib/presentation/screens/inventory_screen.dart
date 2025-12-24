import 'package:flutter/material.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';

/// Inventory Screen
class InventoryScreen extends StatelessWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const InventoryScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return BasePageScreen(
      currentRoute: '/inventory',
      onNavigate: onNavigate,
      onLogout: onLogout,
      pageTitle: 'Inventory',
      pageSubtitle: 'Manage your inventory items',
      pageIcon: Icons.inventory_2,
      iconBackgroundColor: const Color(0xFFF0F9FF),
      searchController: searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {
          // TODO: Navigate to add inventory item
        },
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Item',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: EmptyStateWidget(
        icon: Icons.inventory_2,
        title: 'No inventory items found',
        subtitle: 'Start managing inventory by adding your first item',
        buttonLabel: 'Add Your First Item',
        onButtonPressed: () {
          // TODO: Navigate to add inventory item
        },
      ),
    );
  }
}
