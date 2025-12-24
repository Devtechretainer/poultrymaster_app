import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseDataSource dataSource;
  final String? authToken;

  ExpenseRepositoryImpl({required this.dataSource, this.authToken});

  @override
  Future<List<Expense>> getAllExpenses(
      String userId, String farmId) async {
    try {
      final expenses = await dataSource.getAllExpenses(
        userId,
        farmId,
        authToken,
      );
      return expenses.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get expenses: $e');
    }
  }

  @override
  Future<Expense?> getExpenseById(
    int id,
    String userId,
    String farmId,
  ) async {
    try {
      final expense = await dataSource.getExpenseById(
        id,
        userId,
        farmId,
        authToken,
      );
      return expense?.toEntity();
    } catch (e) {
      throw Exception('Failed to get expense: $e');
    }
  }

  @override
  Future<List<Expense>> getExpensesByFlockId(
      int flockId, String userId, String farmId) async {
    try {
      final expenses = await dataSource.getExpensesByFlockId(
        flockId,
        userId,
        farmId,
        authToken,
      );
      return expenses.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get expenses by flock ID: $e');
    }
  }

  @override
  Future<Expense> createExpense(Expense expense) async {
    try {
      final model = ExpenseModel.fromEntity(expense);
      final created = await dataSource.createExpense(model, authToken);
      return created.toEntity();
    } catch (e) {
      throw Exception('Failed to create expense: $e');
    }
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    try {
      final model = ExpenseModel.fromEntity(expense);
      await dataSource.updateExpense(expense.expenseId, model, authToken);
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  @override
  Future<void> deleteExpense(
    int id,
    String userId,
    String farmId,
  ) async {
    try {
      await dataSource.deleteExpense(id, userId, farmId, authToken);
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }
}
