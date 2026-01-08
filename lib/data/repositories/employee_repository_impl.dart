import '../../domain/entities/create_employee_request.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_datasource.dart';

class EmployeeRepositoryImpl implements IEmployeeRepository {
  final EmployeeDataSource dataSource;

  EmployeeRepositoryImpl(this.dataSource);

  @override
  Future<Employee> createEmployee(CreateEmployeeRequest request) {
    return dataSource.createEmployee(request);
  }

  @override
  Future<List<Employee>> getEmployees() {
    return dataSource.getEmployees();
  }

  @override
  Future<Employee> updateEmployee(Employee employee) {
    return dataSource.updateEmployee(employee);
  }

  @override
  Future<void> deleteEmployee(String employeeId) {
    return dataSource.deleteEmployee(employeeId);
  }
}
