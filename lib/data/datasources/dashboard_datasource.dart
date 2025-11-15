import 'package:dio/dio.dart';
import '../models/dashboard_summary_model.dart';

/// Data source - Handles dashboard API calls
class DashboardDataSource {
  final Dio dio;
  final String baseUrl;

  DashboardDataSource({required this.dio, required this.baseUrl});

  /// Get dashboard summary from API
  /// Endpoint: GET /api/Dashboard/Summary?farmId={farmId}
  Future<DashboardSummaryModel> getDashboardSummary(
    String farmId,
    String? token,
  ) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/Dashboard/Summary',
        queryParameters: {'farmId': farmId},
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return DashboardSummaryModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to load dashboard: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('API Error: ${e.message}');
      }
      rethrow;
    }
  }
}
