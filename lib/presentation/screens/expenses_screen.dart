import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/expense_providers.dart';
import '../../domain/entities/expense.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import 'add_edit_expense_screen.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const ExpensesScreen({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(expenseControllerProvider.notifier).loadExpenses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddExpense() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddEditExpenseScreen()));
  }

  void _navigateToEditExpense(Expense expense) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddEditExpenseScreen(expense: expense)),
    );
  }

  Future<void> _deleteExpense(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Are you sure you want to delete this expense record?',
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
      await ref.read(expenseControllerProvider.notifier).deleteExpense(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseState = ref.watch(expenseControllerProvider);
    final expenses = expenseState.expenses;
    final isLoading = expenseState.isLoading;
    final error = expenseState.error;

    return BasePageScreen(
      currentRoute: '/expenses',
      onNavigate: widget.onNavigate,
      onLogout: widget.onLogout,
      pageTitle: 'Expenses',
      pageSubtitle: 'Track your farm expenses',
      pageIcon: Icons.attach_money,
      iconBackgroundColor: const Color(0xFFFEF2F2),
      searchController: _searchController,
      actionButton: ElevatedButton.icon(
        onPressed: _navigateToAddExpense,
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text(
          'Add Expense',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: _buildContent(expenses, isLoading, error),
    );
  }

  Widget _buildContent(List<Expense> expenses, bool isLoading, String? error) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: LoadingWidget.large(),
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
                  ref.read(expenseControllerProvider.notifier).loadExpenses();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (expenses.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.attach_money,
        title: 'No expenses found',
        subtitle: 'Start tracking expenses by adding your first record',
        buttonLabel: 'Add Your First Expense',
        onButtonPressed: _navigateToAddExpense,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _ExpenseCard(
            expense: expense,
            index: index + 1,
            onEdit: () => _navigateToEditExpense(expense),
            onDelete: () => _deleteExpense(expense.expenseId),
          ),
        );
      },
    );
  }
}

/// Expense Card Widget - Card-based design
class _ExpenseCard extends StatelessWidget {
  final Expense expense;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExpenseCard({
    required this.expense,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with number and title
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    expense.category,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Info items with icons
            _InfoItem(
              icon: Icons.attach_money_outlined,
              label: 'Amount',
              value: 'GH₵${expense.amount.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 12),
            _InfoItem(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: expense.expenseDate.toLocal().toString().split(' ')[0],
            ),
            const SizedBox(height: 12),
            _InfoItem(
              icon: Icons.payment_outlined,
              label: 'Payment',
              value: expense.paymentMethod,
            ),
            if (expense.description != null &&
                expense.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _InfoItem(
                icon: Icons.description_outlined,
                label: 'Description',
                value: expense.description!,
              ),
            ],
            const SizedBox(height: 16),
            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.grey[800],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Info Item Widget - Displays icon, label, and value
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
