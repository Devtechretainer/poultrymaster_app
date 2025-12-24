import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/base_page_screen.dart';
import '../../../../../presentation/widgets/empty_state_widget.dart';

/// Expenses Screen
class ExpensesScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const ExpensesScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _expenses = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageScreen(
      currentRoute: '/expenses',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Expenses',
      pageSubtitle: 'Track and manage your expenses',
      pageIcon: Icons.attach_money,
      iconBackgroundColor: const Color(0xFFFED7AA), // bg-orange-100
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Expense',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB), // bg-blue-600
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _expenses.isEmpty
          ? EmptyStateWidget(
              icon: Icons.attach_money,
              title: 'No expenses found',
              subtitle: 'Get started by adding your first expense',
              buttonLabel: 'Add Your First Expense',
              onButtonPressed: () {},
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Expenses List')),
            ),
    );
  }
}
