import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';

/// Sales Screen
class SalesScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const SalesScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _sales = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/sales',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Sales',
      pageSubtitle: 'Track and manage your sales transactions',
      pageIcon: Icons.shopping_bag,
      iconBackgroundColor: const Color(0xFFD1FAE5), // bg-green-100
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Sale',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // bg-blue-600
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _sales.isEmpty
          ? EmptyStateWidget(
              icon: Icons.shopping_bag,
              title: 'No sales found',
              subtitle: 'Get started by adding your first sale',
              buttonLabel: 'Add Your First Sale',
              onButtonPressed: () {},
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Sales List')),
            ),
    );
  }
}
