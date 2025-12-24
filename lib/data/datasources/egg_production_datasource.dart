import 'package:dio/dio.dart';
import '../models/egg_production_model.dart';

class EggProductionDataSource {
  final Dio dio;
  final String baseUrl;

  EggProductionDataSource({required this.dio, required this.baseUrl});

  Future<List<EggProductionModel>> getAllEggProductions(
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/EggProduction',
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
                    EggProductionModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      } else {
        throw Exception(
            'Failed to load egg productions: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<EggProductionModel?> getEggProductionById(
    int id,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/EggProduction/$id',
        queryParameters: {'userId': userId, 'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return EggProductionModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
            'Failed to load egg production: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<EggProductionModel> createEggProduction(
    EggProductionModel eggProduction,
    String? token,
  ) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/EggProduction',
        data: eggProduction.toJson(),
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return EggProductionModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage =
            response.data?['message'] ??
            'Failed to create egg production: ${response.statusCode}';
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

  Future<void> updateEggProduction(
    int id,
    EggProductionModel eggProduction,
    String? token,
  ) async {
    try {
      final response = await dio.put(
        '$baseUrl/api/EggProduction/$id',
        data: eggProduction.toJson(),
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
            'Failed to update egg production: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<void> deleteEggProduction(
    int id,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.delete(
        '$baseUrl/api/EggProduction/$id',
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
            'Failed to delete egg production: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }
}
