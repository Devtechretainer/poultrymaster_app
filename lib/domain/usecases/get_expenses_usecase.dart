import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpensesUseCase {
  final ExpenseRepository repository;

  GetExpensesUseCase(this.repository);

  Future<List<Expense>> call(String userId, String farmId) async {
    return await repository.getAllExpenses(userId, farmId);
  }
}
