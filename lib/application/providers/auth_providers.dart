import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/app_config.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../controllers/auth_controller.dart';
import '../states/auth_state.dart';

/// Dependency Injection Providers using Riverpod

// Dio instance for auth
final authDioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  // Configure Dio
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 60), // Increased timeout
    receiveTimeout: const Duration(seconds: 60), // Increased timeout
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    validateStatus: (status) {
      return status! < 500; // Accept all status codes < 500
    },
  );

  return dio;
});

// Base URL for authentication API
final authBaseUrlProvider = Provider<String>((ref) {
  // User Management API URL (Login API) - loaded from environment
  return AppConfig.authApiBaseUrl;
});

// Data sources
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final dio = ref.watch(authDioProvider);
  final baseUrl = ref.watch(authBaseUrlProvider);
  return AuthDataSource(dio: dio, baseUrl: baseUrl);
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

// Use cases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ForgotPasswordUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

// Controller - Manages state and calls use cases
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final loginUseCase = ref.watch(loginUseCaseProvider);
    final registerUseCase = ref.watch(registerUseCaseProvider);
    final forgotPasswordUseCase = ref.watch(forgotPasswordUseCaseProvider);
    final logoutUseCase = ref.watch(logoutUseCaseProvider);
    final authRepository = ref.watch(authRepositoryProvider);

    return AuthController(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      forgotPasswordUseCase: forgotPasswordUseCase,
      logoutUseCase: logoutUseCase,
      authRepository: authRepository,
    );
  },
);
