import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpenseUseCase {
  final ExpenseRepository repository;

  GetExpenseUseCase(this.repository);

  Future<Expense?> call(int id, String userId, String farmId) async {
    return await repository.getExpenseById(id, userId, farmId);
  }
}
