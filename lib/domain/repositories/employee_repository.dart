import 'package:poultrymaster_app/domain/entities/employee.dart';
import 'package:poultrymaster_app/domain/entities/create_employee_request.dart';

abstract class IEmployeeRepository {
  Future<Employee> createEmployee(CreateEmployeeRequest request);
  Future<List<Employee>> getEmployees();
  Future<Employee> updateEmployee(Employee employee);
  Future<void> deleteEmployee(String employeeId);
}
