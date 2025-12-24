import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository repository;

  DeleteExpenseUseCase(this.repository);

  Future<void> call(int id, String userId, String farmId) async {
    return await repository.deleteExpense(id, userId, farmId);
  }
}
