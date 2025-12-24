import 'package:dio/dio.dart';
import '../models/production_record_model.dart';

class ProductionRecordDataSource {
  final Dio dio;
  final String baseUrl;

  ProductionRecordDataSource({required this.dio, required this.baseUrl});

  Future<List<ProductionRecordModel>> getAllProductionRecords(
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/ProductionRecord',
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
                (json) =>
                    ProductionRecordModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      } else {
        throw Exception(
            'Failed to load production records: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<ProductionRecordModel?> getProductionRecordById(
    int id,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/ProductionRecord/$id',
        queryParameters: {'userId': userId, 'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ProductionRecordModel.fromJson(
            response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
            'Failed to load production record: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<ProductionRecordModel> createProductionRecord(
    ProductionRecordModel productionRecord,
    String? token,
  ) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/ProductionRecord',
        data: productionRecord.toJson(),
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ProductionRecordModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        final errorMessage =
            response.data?['message'] ??
            'Failed to create production record: ${response.statusCode}';
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

  Future<void> updateProductionRecord(
    int id,
    ProductionRecordModel productionRecord,
    String? token,
  ) async {
    try {
      final response = await dio.put(
        '$baseUrl/api/ProductionRecord/$id',
        data: productionRecord.toJson(),
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
            'Failed to update production record: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<void> deleteProductionRecord(
    int id,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.delete(
        '$baseUrl/api/ProductionRecord/$id',
        queryParameters: {'userId': userId, 'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
            'Failed to delete production record: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }
}
