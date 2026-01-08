# Implementation Steps for Adding Employee Feature

This document outlines the steps taken to implement the "Add Employee" feature in the `poultrymaster_app` Flutter application. The implementation follows the existing clean architecture and Riverpod state management patterns.

## 1. Domain Layer

Created the necessary domain models and repository interface to define the business logic for employees.

- **`lib/domain/entities/employee.dart`**: Defines the `Employee` entity with fields corresponding to the data returned by the API.
- **`lib/domain/entities/create_employee_request.dart`**: Defines the data structure for the request to create a new employee.
- **`lib/domain/repositories/employee_repository.dart`**: Defines the `IEmployeeRepository` interface with methods for `createEmployee` and `getEmployees`.

## 2. Data Layer

Implemented the data layer to handle communication with the remote API.

- **`lib/data/datasources/employee_datasource.dart`**: Created `EmployeeDataSource` to handle the HTTP requests to the `/api/Admin/employees` endpoint. It retrieves the authentication token and farm ID from `shared_preferences` to include in the requests.
- **`lib/data/repositories/employee_repository_impl.dart`**: Created `EmployeeRepositoryImpl` which implements the `IEmployeeRepository` interface and uses the `EmployeeDataSource` to fetch data.

## 3. Application Layer

Set up the state management using Riverpod to connect the UI with the data layer.

- **`lib/application/states/employee_state.dart`**: Created `EmployeeState` to represent the state of the employee feature, including loading status, errors, and the list of employees.
- **`lib/application/controllers/employee_controller.dart`**: Created `EmployeeController` (a `StateNotifier`) to manage the `EmployeeState` and interact with the `IEmployeeRepository`.
- **`lib/application/providers/employee_providers.dart`**: Created providers for the `http.Client`, `EmployeeDataSource`, `IEmployeeRepository`, and `EmployeeController` to handle dependency injection.

## 4. Presentation Layer (UI)

Updated the UI to include the "Add Employee" functionality and display the list of employees.

- **`lib/features/features/employees/presentation/widgets/add_employee_dialog.dart`**: Created a new dialog widget to collect the new employee's information.
- **`lib/features/features/employees/presentation/screens/employees_screen.dart`**:
    - Converted the `EmployeesScreen` to a `ConsumerStatefulWidget` to integrate with Riverpod.
    - Implemented logic to show the `AddEmployeeDialog` when the "Add Employee" button is pressed.
    - On dialog submission, the `createEmployee` method of the `EmployeeController` is called.
    - The screen now listens to the `EmployeeState` to display a loading indicator, handle errors, and show the list of employees.
    - The list of employees is fetched when the screen is initialized.

## 5. Configuration

- **`pubspec.yaml`**: Added the `http` package as a dependency.
- **`lib/data/datasources/employee_datasource.dart`**: Corrected the API endpoint to use `AppConfig.authApiBaseUrl`, ensuring the requests are sent to the correct user management API.
