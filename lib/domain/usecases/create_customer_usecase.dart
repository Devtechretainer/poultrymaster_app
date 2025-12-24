import '../entities/customer.dart';
import '../repositories/customer_repository.dart';

/// Use case - Create a new customer
class CreateCustomerUseCase {
  final CustomerRepository repository;

  CreateCustomerUseCase(this.repository);

  Future<Customer> call(Customer customer) async {
    return await repository.createCustomer(customer);
  }
}
