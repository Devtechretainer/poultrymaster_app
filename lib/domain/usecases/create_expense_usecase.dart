import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class CreateExpenseUseCase {
  final ExpenseRepository repository;

  CreateExpenseUseCase(this.repository);

  Future<Expense> call(Expense expense) async {
    return await repository.createExpense(expense);
  }
}
