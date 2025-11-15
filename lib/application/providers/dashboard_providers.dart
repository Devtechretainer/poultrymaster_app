import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../data/datasources/dashboard_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../controllers/dashboard_controller.dart';
import '../states/dashboard_state.dart';

/// Dependency Injection Providers for Dashboard

// Dio instance
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// Base URL - Poultry Farm API
final baseUrlProvider = Provider<String>((ref) {
  // Poultry Farm API URL (from launchSettings.json)
  // HTTPS: https://localhost:7190
  // HTTP: http://localhost:5142
  // For production, update this to your deployed API URL
  return 'https://localhost:7190';
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
