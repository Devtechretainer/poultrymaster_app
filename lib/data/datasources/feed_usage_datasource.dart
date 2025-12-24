import 'package:dio/dio.dart';
import '../models/feed_usage_model.dart';

class FeedUsageDataSource {
  final Dio dio;
  final String baseUrl;

  FeedUsageDataSource({required this.dio, required this.baseUrl});

  Future<List<FeedUsageModel>> getAllFeedUsages(
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/FeedUsage',
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
                (json) => FeedUsageModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load feed usages: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<FeedUsageModel?> getFeedUsageById(
    int id,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/FeedUsage/$id',
        queryParameters: {'userId': userId, 'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return FeedUsageModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load feed usage: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<FeedUsageModel> createFeedUsage(
    FeedUsageModel feedUsage,
    String? token,
  ) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/FeedUsage',
        data: feedUsage.toJson(),
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return FeedUsageModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        final errorMessage =
            response.data?['message'] ??
            'Failed to create feed usage: ${response.statusCode}';
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

  Future<void> updateFeedUsage(
    int id,
    FeedUsageModel feedUsage,
    String? token,
  ) async {
    try {
      final response = await dio.put(
        '$baseUrl/api/FeedUsage/$id',
        data: feedUsage.toJson(),
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to update feed usage: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }

  Future<void> deleteFeedUsage(
    int id,
    String userId,
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.delete(
        '$baseUrl/api/FeedUsage/$id',
        queryParameters: {'userId': userId, 'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete feed usage: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }
}
