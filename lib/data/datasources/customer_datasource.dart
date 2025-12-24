import 'package:dio/dio.dart';
import '../models/customer_model.dart';

/// Data source - Handles customer API calls
class CustomerDataSource {
  final Dio dio;
  final String baseUrl;

  CustomerDataSource({required this.dio, required this.baseUrl});

  /// Get all customers
  /// Endpoint: GET /api/Customer?userId={userId}&farmId={farmId}
  Future<List<CustomerModel>> getAllCustomers(
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/Customer',
        queryParameters: {'userId': userId, 'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data
              .map(
                (json) => CustomerModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load customers: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  /// Get customer by ID
  /// Endpoint: GET /api/Customer/{id}?userId={userId}&farmId={farmId}
  Future<CustomerModel?> getCustomerById(
    int customerId,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/Customer/$customerId',
        queryParameters: {'userId': userId, 'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return CustomerModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load customer: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  /// Create customer
  /// Endpoint: POST /api/Customer
  Future<CustomerModel> createCustomer(
    CustomerModel customer,
    String? token,
  ) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/Customer',
        data: customer.toJson(),
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return CustomerModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage =
            response.data?['message'] ??
            'Failed to create customer: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? e.message;
        throw Exception('API Error: $errorMessage');
      }
      rethrow;
    }
  }

  /// Update customer
  /// Endpoint: PUT /api/Customer/{id}
  Future<void> updateCustomer(
    int customerId,
    CustomerModel customer,
    String? token,
  ) async {
    try {
      final response = await dio.put(
        '$baseUrl/api/Customer/$customerId',
        data: customer.toJson(),
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to update customer: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  /// Delete customer
  /// Endpoint: DELETE /api/Customer/{id}?userId={userId}&farmId={farmId}
  Future<void> deleteCustomer(
    int customerId,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.delete(
        '$baseUrl/api/Customer/$customerId',
        queryParameters: {'userId': userId, 'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete customer: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }
}
