import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/expense_providers.dart';
import '../../domain/entities/expense.dart';
import '../widgets/base_page_screen.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/unified_list_card_widget.dart';
import '../widgets/ereceipt_detail_widget.dart';
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

  void _showExpenseDetail(Expense expense) {
    final dateTime = expense.expenseDate.toLocal();
    final dateStr = dateTime.toString().split(' ')[0];
    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EReceiptDetailWidget(
          title: 'Expense Details',
          sections: [
            // Item Card Section
            DetailSection(
              type: DetailSectionType.itemCard,
              title: expense.category,
              subtitle: 'Expense | Amount: GH₵${expense.amount.toStringAsFixed(2)}',
              footer: 'Date: $dateStr',
              icon: Icons.attach_money_outlined,
            ),
            // Expense Information Section
            DetailSection(
              type: DetailSectionType.infoList,
              title: 'Expense Information',
              items: [
                DetailItem(
                  label: 'Expense ID',
                  value: 'EXP-${expense.expenseId}',
                ),
                DetailItem(
                  label: 'Category',
                  value: expense.category,
                ),
                DetailItem(
                  label: 'Expense Date',
                  value: '$dateStr | $timeStr',
                ),
                if (expense.description != null &&
                    expense.description!.isNotEmpty)
                  DetailItem(
                    label: 'Description',
                    value: expense.description!,
                  ),
              ],
            ),
            // Payment Summary Section
            DetailSection(
              type: DetailSectionType.summary,
              title: 'Payment Summary',
              items: [
                DetailItem(
                  label: 'Sub Total',
                  value: 'GH₵${expense.amount.toStringAsFixed(2)}',
                ),
                DetailItem(
                  label: 'Payment Method',
                  value: expense.paymentMethod,
                ),
              ],
            ),
          ],
          actionButtonLabel: 'Edit Expense',
          actionButtonColor: const Color(0xFF2563EB),
          onActionPressed: () {
            Navigator.of(context).pop();
            _navigateToEditExpense(expense);
          },
        ),
      ),
    );
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
      showSearchInHeader: true, // Show search in page header
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
      padding: EdgeInsets.zero, // No padding for end-to-end cards
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        final fields = <CardField>[
          CardField(
            label: 'Amount',
            value: 'GH₵${expense.amount.toStringAsFixed(2)}',
          ),
          CardField(
            label: 'Date',
            value: expense.expenseDate.toLocal().toString().split(' ')[0],
          ),
          CardField(
            label: 'Payment',
            value: expense.paymentMethod,
          ),
        ];
        if (expense.description != null && expense.description!.isNotEmpty) {
          fields.add(CardField(label: 'Description', value: expense.description!));
        }
        
        return UnifiedListCardWidget(
          id: 'EXP-${expense.expenseId}',
          title: expense.category,
          fields: fields,
          onEdit: () => _navigateToEditExpense(expense),
          onDelete: () => _deleteExpense(expense.expenseId),
          onSend: () => _showExpenseDetail(expense),
          sendButtonLabel: 'View Details',
        );
      },
    );
  }
}
