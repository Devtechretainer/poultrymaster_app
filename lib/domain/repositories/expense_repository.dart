import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getAllExpenses(String userId, String farmId);

  Future<Expense?> getExpenseById(
    int id,
    String userId,
    String farmId,
  );

  Future<List<Expense>> getExpensesByFlockId(
    int flockId,
    String userId,
    String farmId,
  );

  Future<Expense> createExpense(Expense expense);

  Future<void> updateExpense(Expense expense);

  Future<void> deleteExpense(
    int id,
    String userId,
    String farmId,
  );
}
