import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

/// Use case - Update an existing customer
class UpdateCustomerUseCase {
  final CustomerRepository repository;

  UpdateCustomerUseCase(this.repository);

  Future<void> call(Customer customer) async {
    return await repository.updateCustomer(customer);
  }
}
