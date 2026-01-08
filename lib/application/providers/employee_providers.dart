import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:poultrymaster_app/application/controllers/employee_controller.dart';
import 'package:poultrymaster_app/application/states/employee_state.dart';
import 'package:poultrymaster_app/data/datasources/employee_datasource.dart';
import 'package:poultrymaster_app/data/repositories/employee_repository_impl.dart';
import 'package:poultrymaster_app/domain/repositories/employee_repository.dart';

// HTTP Client
final employeeHttpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

// DataSource
final employeeDataSourceProvider = Provider<EmployeeDataSource>((ref) {
  final client = ref.watch(employeeHttpClientProvider);
  return EmployeeDataSource(client);
});

// Repository
final employeeRepositoryProvider = Provider<IEmployeeRepository>((ref) {
  final dataSource = ref.watch(employeeDataSourceProvider);
  return EmployeeRepositoryImpl(dataSource);
});

// Controller
final employeeControllerProvider =
    StateNotifierProvider<EmployeeController, EmployeeState>((ref) {
  final repository = ref.watch(employeeRepositoryProvider);
  return EmployeeController(repository);
});
