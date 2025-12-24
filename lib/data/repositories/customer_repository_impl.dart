import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_datasource.dart';
import '../models/customer_model.dart';

/// Repository implementation - Coordinates customer data sources
class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerDataSource dataSource;
  final String? authToken;

  CustomerRepositoryImpl({required this.dataSource, this.authToken});

  @override
  Future<List<Customer>> getAllCustomers(String userId, String farmId) async {
    try {
      final customers = await dataSource.getAllCustomers(
        userId,
        farmId,
        authToken,
      );
      return customers.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get customers: $e');
    }
  }

  @override
  Future<Customer?> getCustomerById(
    int customerId,
    String userId,
    String farmId,
  ) async {
    try {
      final customer = await dataSource.getCustomerById(
        customerId,
        userId,
        farmId,
        authToken,
      );
      return customer?.toEntity();
    } catch (e) {
      throw Exception('Failed to get customer: $e');
    }
  }

  @override
  Future<Customer> createCustomer(Customer customer) async {
    try {
      final model = CustomerModel.fromEntity(customer);
      final created = await dataSource.createCustomer(model, authToken);
      return created.toEntity();
    } catch (e) {
      throw Exception('Failed to create customer: $e');
    }
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    try {
      if (customer.customerId == null) {
        throw Exception('Customer ID is required for update');
      }
      final model = CustomerModel.fromEntity(customer);
      await dataSource.updateCustomer(customer.customerId!, model, authToken);
    } catch (e) {
      throw Exception('Failed to update customer: $e');
    }
  }

  @override
  Future<void> deleteCustomer(
    int customerId,
    String userId,
    String farmId,
  ) async {
    try {
      await dataSource.deleteCustomer(customerId, userId, farmId, authToken);
    } catch (e) {
      throw Exception('Failed to delete customer: $e');
    }
  }
}
