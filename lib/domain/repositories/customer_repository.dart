import '../entities/customer.dart';

/// Repository interface - Defines customer data operations
abstract class CustomerRepository {
  /// Get all customers for a farm
  Future<List<Customer>> getAllCustomers(String userId, String farmId);

  /// Get customer by ID
  Future<Customer?> getCustomerById(
    int customerId,
    String userId,
    String farmId,
  );

  /// Create a new customer
  Future<Customer> createCustomer(Customer customer);

  /// Update an existing customer
  Future<void> updateCustomer(Customer customer);

  /// Delete a customer
  Future<void> deleteCustomer(int customerId, String userId, String farmId);
}
