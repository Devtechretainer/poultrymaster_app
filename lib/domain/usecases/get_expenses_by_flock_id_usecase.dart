import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpensesByFlockIdUseCase {
  final ExpenseRepository repository;

  GetExpensesByFlockIdUseCase(this.repository);

  Future<List<Expense>> call(int flockId, String userId, String farmId) async {
    return await repository.getExpensesByFlockId(flockId, userId, farmId);
  }
}
