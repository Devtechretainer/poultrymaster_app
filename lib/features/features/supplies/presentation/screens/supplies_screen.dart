import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';

/// Supplies Screen
class SuppliesScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const SuppliesScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<SuppliesScreen> createState() => _SuppliesScreenState();
}

class _SuppliesScreenState extends State<SuppliesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _supplies = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/supplies',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Supplies',
      pageSubtitle: 'Manage your farm supplies',
      pageIcon: Icons.shopping_cart,
      iconBackgroundColor: const Color(0xFFFCE7F3), // bg-pink-100
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Supply',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // bg-blue-600
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _supplies.isEmpty
          ? EmptyStateWidget(
              icon: Icons.shopping_cart,
              title: 'No supplies found',
              subtitle: 'Get started by adding your first supply',
              buttonLabel: 'Add Your First Supply',
              onButtonPressed: () {},
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Supplies List')),
            ),
    );
  }
}
