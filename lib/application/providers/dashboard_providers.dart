import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../core/config/app_config.dart';
import '../../data/datasources/dashboard_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../controllers/dashboard_controller.dart';
import '../states/dashboard_state.dart';

/// Dependency Injection Providers for Dashboard

// Dio instance
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 120), // 2 minutes for connection
    receiveTimeout: const Duration(
      seconds: 120,
    ), // 2 minutes for receiving data
    sendTimeout: const Duration(seconds: 120), // 2 minutes for sending data
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    validateStatus: (status) {
      return status! < 500; // Accept all status codes < 500
    },
  );
  return dio;
});

// Base URL - Poultry Farm API
final baseUrlProvider = Provider<String>((ref) {
  // Poultry Farm API URL - loaded from environment
  return AppConfig.farmApiBaseUrl;
});

// Dashboard data source
final dashboardDataSourceProvider = Provider<DashboardDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final baseUrl = ref.watch(baseUrlProvider);
  return DashboardDataSource(dio: dio, baseUrl: baseUrl);
});

// Dashboard repository
final dashboardRepositoryProvider =
    Provider.family<DashboardRepository, String>((ref, farmId) {
      final dataSource = ref.watch(dashboardDataSourceProvider);
      final authState = ref.watch(authControllerProvider);

      return DashboardRepositoryImpl(
        dataSource: dataSource,
        farmId: farmId,
        authToken: authState.user?.token,
      );
    });

// Use case
final getDashboardSummaryUseCaseProvider =
    Provider.family<GetDashboardSummaryUseCase, String>((ref, farmId) {
      final repository = ref.watch(dashboardRepositoryProvider(farmId));
      return GetDashboardSummaryUseCase(repository);
    });

// Controller
final dashboardControllerProvider =
    StateNotifierProvider.family<DashboardController, DashboardState, String>((
      ref,
      farmId,
    ) {
      final useCase = ref.watch(getDashboardSummaryUseCaseProvider(farmId));
      return DashboardController(
        getDashboardSummaryUseCase: useCase,
        farmId: farmId,
      );
    });
