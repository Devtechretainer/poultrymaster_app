import '../repositories/customer_repository.dart';

/// Use case - Delete a customer
class DeleteCustomerUseCase {
  final CustomerRepository repository;

  DeleteCustomerUseCase(this.repository);

  Future<void> call(int customerId, String userId, String farmId) async {
    return await repository.deleteCustomer(customerId, userId, farmId);
  }
}
