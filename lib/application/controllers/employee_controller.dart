import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrymaster_app/application/states/employee_state.dart';
import 'package:poultrymaster_app/domain/entities/create_employee_request.dart';
import 'package:poultrymaster_app/domain/entities/employee.dart';
import 'package:poultrymaster_app/domain/repositories/employee_repository.dart';

class EmployeeController extends StateNotifier<EmployeeState> {
  final IEmployeeRepository _repository;

  EmployeeController(this._repository) : super(const EmployeeState());

  Future<void> createEmployee(CreateEmployeeRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newEmployee = await _repository.createEmployee(request);
      state = state.copyWith(
        isLoading: false,
        employees: [...state.employees, newEmployee],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchEmployees() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final employees = await _repository.getEmployees();
      state = state.copyWith(isLoading: false, employees: employees);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedEmployee = await _repository.updateEmployee(employee);
      final employees = state.employees
          .map((e) => e.id == updatedEmployee.id ? updatedEmployee : e)
          .toList();
      state = state.copyWith(isLoading: false, employees: employees);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteEmployee(employeeId);
      final employees =
          state.employees.where((e) => e.id != employeeId).toList();
      state = state.copyWith(isLoading: false, employees: employees);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
