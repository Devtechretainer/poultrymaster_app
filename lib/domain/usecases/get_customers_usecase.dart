import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

/// Use case - Get all customers
class GetCustomersUseCase {
  final CustomerRepository repository;

  GetCustomersUseCase(this.repository);

  Future<List<Customer>> call(String userId, String farmId) async {
    return await repository.getAllCustomers(userId, farmId);
  }
}
