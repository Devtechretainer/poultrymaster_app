import 'package:flutter/material.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';

/// Supplies Screen
class SuppliesScreen extends StatelessWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const SuppliesScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return BasePageScreen(
      currentRoute: '/supplies',
      onNavigate: onNavigate,
      onLogout: onLogout,
      pageTitle: 'Supplies',
      pageSubtitle: 'Manage farm supplies',
      pageIcon: Icons.shopping_cart,
      iconBackgroundColor: const Color(0xFFF5F3FF),
      searchController: searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {
          // TODO: Navigate to add supply
        },
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Supply',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: EmptyStateWidget(
        icon: Icons.shopping_cart,
        title: 'No supplies found',
        subtitle: 'Start managing supplies by adding your first item',
        buttonLabel: 'Add Your First Supply',
        onButtonPressed: () {
          // TODO: Navigate to add supply
        },
      ),
    );
  }
}
