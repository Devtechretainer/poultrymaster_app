import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/create_expense_usecase.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/get_expenses_by_flock_id_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import '../../domain/usecases/update_expense_usecase.dart';
import '../providers/dashboard_providers.dart';
import '../states/expense_state.dart';

class ExpenseController extends StateNotifier<ExpenseState> {
  final GetExpensesUseCase getExpensesUseCase;
  final GetExpensesByFlockIdUseCase getExpensesByFlockIdUseCase;
  final CreateExpenseUseCase createExpenseUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final String userId;
  final String farmId;
  final Ref ref;

  ExpenseController({
    required this.getExpensesUseCase,
    required this.getExpensesByFlockIdUseCase,
    required this.createExpenseUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
    required this.userId,
    required this.farmId,
    required this.ref,
  }) : super(const ExpenseState()) {
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final expenses = await getExpensesUseCase(userId, farmId);
      state = state.copyWith(expenses: expenses, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<List<Expense>> loadExpensesByFlockId(int flockId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final expenses = await getExpensesByFlockIdUseCase(flockId, userId, farmId);
      state = state.copyWith(isLoading: false);
      return expenses;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return [];
    }
  }

  Future<bool> createExpense(Expense expense) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await createExpenseUseCase(expense);
      await loadExpenses();
      ref.invalidate(dashboardControllerProvider(farmId));
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> updateExpense(Expense expense) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await updateExpenseUseCase(expense);
      await loadExpenses();
      ref.invalidate(dashboardControllerProvider(farmId));
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> deleteExpense(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await deleteExpenseUseCase(id, userId, farmId);
      await loadExpenses();
      ref.invalidate(dashboardControllerProvider(farmId));
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
