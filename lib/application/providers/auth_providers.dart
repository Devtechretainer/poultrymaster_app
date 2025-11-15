import 'dart:io' show HttpClient, X509Certificate;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // Configure Dio for localhost/development
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    validateStatus: (status) {
      return status! < 500; // Accept all status codes < 500
    },
  );

  // Handle self-signed certificates (for localhost development)
  // WARNING: Only for development! Remove in production
  // Only apply SSL certificate bypass on non-web platforms
  if (!kIsWeb) {
    try {
      // Import IOHttpClientAdapter only on non-web platforms
      final adapter = dio.httpClientAdapter;
      if (adapter is DefaultHttpClientAdapter) {
        adapter.onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
                // Allow localhost connections with self-signed certificates
                if (host == 'localhost' || host == '127.0.0.1') {
                  return true;
                }
                return false;
              };
          return client;
        };
      }
    } catch (e) {
      // Ignore if platform doesn't support IOHttpClientAdapter
    }
  }

  return dio;
});

// Base URL for authentication API
final authBaseUrlProvider = Provider<String>((ref) {
  // User Management API URL (Login API)
  // Login endpoint: POST https://localhost:7010/api/Authentication/login
  return 'https://localhost:7010';
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
