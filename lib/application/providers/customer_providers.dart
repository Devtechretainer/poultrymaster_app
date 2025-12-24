import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/dashboard_providers.dart';
import '../../data/datasources/customer_datasource.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/usecases/create_customer_usecase.dart';
import '../../domain/usecases/delete_customer_usecase.dart';
import '../../domain/usecases/get_customers_usecase.dart';
import '../../domain/usecases/update_customer_usecase.dart';
import '../controllers/customer_controller.dart';
import '../states/customer_state.dart';

/// Dependency Injection Providers for Customer

// Customer data source
final customerDataSourceProvider = Provider<CustomerDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = ref.watch(baseUrlProvider);
  return CustomerDataSource(dio: dio, baseUrl: baseUrl);
});

// Customer repository
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final dataSource = ref.watch(customerDataSourceProvider);
  final authState = ref.watch(authControllerProvider);

  return CustomerRepositoryImpl(
    dataSource: dataSource,
    authToken: authState.user?.token,
  );
});

// Use cases
final getCustomersUseCaseProvider = Provider<GetCustomersUseCase>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return GetCustomersUseCase(repository);
});

final createCustomerUseCaseProvider = Provider<CreateCustomerUseCase>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return CreateCustomerUseCase(repository);
});

final updateCustomerUseCaseProvider = Provider<UpdateCustomerUseCase>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return UpdateCustomerUseCase(repository);
});

final deleteCustomerUseCaseProvider = Provider<DeleteCustomerUseCase>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return DeleteCustomerUseCase(repository);
});

// Controller
final customerControllerProvider =
    StateNotifierProvider<CustomerController, CustomerState>((ref) {
  final getCustomersUseCase = ref.watch(getCustomersUseCaseProvider);
  final createCustomerUseCase = ref.watch(createCustomerUseCaseProvider);
  final updateCustomerUseCase = ref.watch(updateCustomerUseCaseProvider);
  final deleteCustomerUseCase = ref.watch(deleteCustomerUseCaseProvider);
  final authState = ref.watch(authControllerProvider);
  final userId = authState.user?.id ?? '';
  final farmId = authState.user?.farmId ?? authState.user?.id ?? '';

  return CustomerController(
    getCustomersUseCase: getCustomersUseCase,
    createCustomerUseCase: createCustomerUseCase,
    updateCustomerUseCase: updateCustomerUseCase,
    deleteCustomerUseCase: deleteCustomerUseCase,
    userId: userId,
    farmId: farmId,
    ref: ref,
  );
});
