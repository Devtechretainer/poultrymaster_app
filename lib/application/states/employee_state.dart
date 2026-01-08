import 'package:poultrymaster_app/domain/entities/employee.dart';

class EmployeeState {
  final bool isLoading;
  final String? error;
  final List<Employee> employees;
  final Employee? currentEmployee;

  const EmployeeState({
    this.isLoading = false,
    this.error,
    this.employees = const [],
    this.currentEmployee,
  });

  EmployeeState copyWith({
    bool? isLoading,
    String? error,
    List<Employee>? employees,
    Employee? currentEmployee,
  }) {
    return EmployeeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      employees: employees ?? this.employees,
      currentEmployee: currentEmployee ?? this.currentEmployee,
    );
  }
}
