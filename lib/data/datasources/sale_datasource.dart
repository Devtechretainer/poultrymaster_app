import 'package:dio/dio.dart';
import '../models/sale_model.dart';

class SaleDataSource {
  final Dio dio;
  final String baseUrl;

  SaleDataSource({required this.dio, required this.baseUrl});

  Future<List<SaleModel>> getAllSales(
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/Sale',
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
                (json) => SaleModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load sales: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<SaleModel?> getSaleById(
    int id,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/Sale/$id',
        queryParameters: {'userId': userId, 'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return SaleModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load sale: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<List<SaleModel>> getSalesByFlockId(
    int flockId,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/Sale/ByFlock/$flockId',
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
                (json) => SaleModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load sales by flock ID: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<SaleModel> createSale(
    SaleModel sale,
    String? token,
  ) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/Sale',
        data: sale.toJson(),
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return SaleModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage =
            response.data?['message'] ??
            'Failed to create sale: ${response.statusCode}';
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

  Future<void> updateSale(
    int id,
    SaleModel sale,
    String? token,
  ) async {
    try {
      final response = await dio.put(
        '$baseUrl/api/Sale/$id',
        data: sale.toJson(),
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to update sale: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<void> deleteSale(
    int id,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.delete(
        '$baseUrl/api/Sale/$id',
        queryParameters: {'userId': userId, 'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete sale: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }
}
