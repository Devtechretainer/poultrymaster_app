import 'package:dio/dio.dart';
import '../models/expense_model.dart';

class ExpenseDataSource {
  final Dio dio;
  final String baseUrl;

  ExpenseDataSource({required this.dio, required this.baseUrl});

  Future<List<ExpenseModel>> getAllExpenses(
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/Expense',
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
                (json) => ExpenseModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load expenses: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<ExpenseModel?> getExpenseById(
    int id,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/Expense/$id',
        queryParameters: {'userId': userId, 'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ExpenseModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load expense: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<List<ExpenseModel>> getExpensesByFlockId(
    int flockId,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/Expense/ByFlock/$flockId',
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
                (json) => ExpenseModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load expenses by flock ID: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<ExpenseModel> createExpense(
    ExpenseModel expense,
    String? token,
  ) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/Expense',
        data: expense.toJson(),
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ExpenseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage =
            response.data?['message'] ??
            'Failed to create expense: ${response.statusCode}';
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

  Future<void> updateExpense(
    int id,
    ExpenseModel expense,
    String? token,
  ) async {
    try {
      final response = await dio.put(
        '$baseUrl/api/Expense/$id',
        data: expense.toJson(),
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to update expense: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<void> deleteExpense(
    int id,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.delete(
        '$baseUrl/api/Expense/$id',
        queryParameters: {'userId': userId, 'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete expense: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }
}
