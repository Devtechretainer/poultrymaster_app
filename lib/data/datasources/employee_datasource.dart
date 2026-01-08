import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/create_employee_request.dart';
import '../../domain/entities/employee.dart';
import '../../core/config/app_config.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint
import '../models/user_model.dart'; // Import UserModel
import '../repositories/auth_repository_impl.dart'; // Import AuthRepositoryImpl to get _currentUserKey

class EmployeeDataSource {
  final http.Client client;

  EmployeeDataSource(this.client);

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AuthRepositoryImpl.currentUserKey);
    String? token;

    debugPrint('[Auth] Reading userJson from SharedPreferences: $userJson');

    if (userJson != null) {
      try {
        final userModel = UserModel.fromJson(jsonDecode(userJson));
        token = userModel.token;
      } catch (e) {
        debugPrint('[Auth] Error decoding user model from shared preferences: $e');
      }
    }

    debugPrint('[Auth] Extracted token: $token');

    if (token == null) {
      debugPrint('[Auth] Error: Authentication token is null or not found in user data.');
      // You might want to throw an exception or handle this case more gracefully
      // For now, we'll return headers without a token, which will likely result in a 401
    }

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  Future<String?> _getFarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AuthRepositoryImpl.currentUserKey);
    String? farmId;

    if (userJson != null) {
      try {
        final userModel = UserModel.fromJson(jsonDecode(userJson));
        farmId = userModel.farmId;
      } catch (e) {
        debugPrint('Error decoding user model for farmId from shared preferences: $e');
      }
    }
    return farmId;
  }

  Future<Employee> createEmployee(CreateEmployeeRequest request) async {
    final farmId = await _getFarmId();
    if (farmId == null) {
      debugPrint('Error: Farm ID not found in shared preferences.');
      throw Exception('Farm ID not found');
    }
    
    final url = Uri.parse('${AppConfig.authApiBaseUrl}/api/Admin/employees');
    final headers = await _getHeaders();
    final body = jsonEncode(request.toJson());

    debugPrint('createEmployee Request URL: $url');
    debugPrint('createEmployee Request Headers: $headers');
    debugPrint('createEmployee Request Body: $body');

    final response = await client.post(url, headers: headers, body: body);

    debugPrint('createEmployee Response Status: ${response.statusCode}');
    debugPrint('createEmployee Response Body: ${response.body}');

    if (response.statusCode == 201) {
      return Employee.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create employee: Status ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<List<Employee>> getEmployees() async {
    final url = Uri.parse('${AppConfig.authApiBaseUrl}/api/Admin/employees');
    final headers = await _getHeaders();

    debugPrint('getEmployees Request URL: $url');
    debugPrint('getEmployees Request Headers: $headers');

    final response = await client.get(url, headers: headers);

    debugPrint('getEmployees Response Status: ${response.statusCode}');
    debugPrint('getEmployees Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees: Status ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<Employee> updateEmployee(Employee employee) async {
    final url = Uri.parse('${AppConfig.authApiBaseUrl}/api/Admin/employees/${employee.id}');
    final headers = await _getHeaders();
    final body = jsonEncode(employee.toJson());

    debugPrint('updateEmployee Request URL: $url');
    debugPrint('updateEmployee Request Headers: $headers');
    debugPrint('updateEmployee Request Body: $body');

    final response = await client.put(url, headers: headers, body: body);

    debugPrint('updateEmployee Response Status: ${response.statusCode}');
    debugPrint('updateEmployee Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return Employee.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 204) {
      // Success, but no content was returned.
      // Return the original employee object as a confirmation.
      return employee;
    } else {
      throw Exception('Failed to update employee: Status ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    final url = Uri.parse('${AppConfig.authApiBaseUrl}/api/Admin/employees/$employeeId');
    final headers = await _getHeaders();

    debugPrint('deleteEmployee Request URL: $url');
    debugPrint('deleteEmployee Request Headers: $headers');

    final response = await client.delete(url, headers: headers);

    debugPrint('deleteEmployee Response Status: ${response.statusCode}');

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete employee: Status ${response.statusCode}, Body: ${response.body}');
    }
  }
}
