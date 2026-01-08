import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/app_config.dart';
import '../../data/datasources/user_profile_datasource.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/usecases/create_user_profile_usecase.dart';
import '../../domain/usecases/delete_user_profile_usecase.dart';
import '../../domain/usecases/find_user_profile_by_username_usecase.dart';
import '../../domain/usecases/find_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../controllers/user_profile_controller.dart';
import '../../core/network/dio_interceptor.dart';
import '../states/user_profile_state.dart';

// Dio instance for UserProfile
final userProfileDioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 120), // 2 minutes for connection
    receiveTimeout: const Duration(
      seconds: 120,
    ), // 2 minutes for receiving data
    sendTimeout: const Duration(seconds: 120), // 2 minutes for sending data
    headers: {'Content-Type': 'application/json'},
  );
  dio.interceptors.add(AuthInterceptor());
  return dio;
});

// Base URL for UserProfile API
final userProfileBaseUrlProvider = Provider<String>((ref) {
  return AppConfig.authApiBaseUrl;
});

// Data sources
final userProfileDataSourceProvider = Provider<UserProfileDataSource>((ref) {
  final dio = ref.watch(userProfileDioProvider);
  final baseUrl = ref.watch(userProfileBaseUrlProvider);
  return UserProfileDataSource(dio: dio, baseUrl: baseUrl);
});

// Repository
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final dataSource = ref.watch(userProfileDataSourceProvider);
  return UserProfileRepositoryImpl(dataSource);
});

// Use cases
final createUserProfileUseCaseProvider = Provider<CreateUserProfileUseCase>((
  ref,
) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return CreateUserProfileUseCase(repository);
});

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((
  ref,
) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return UpdateUserProfileUseCase(repository);
});

final deleteUserProfileUseCaseProvider = Provider<DeleteUserProfileUseCase>((
  ref,
) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return DeleteUserProfileUseCase(repository);
});

final findUserProfileUseCaseProvider = Provider<FindUserProfileUseCase>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return FindUserProfileUseCase(repository);
});

final findUserProfileByUsernameUseCaseProvider =
    Provider<FindUserProfileByUsernameUseCase>((ref) {
      final repository = ref.watch(userProfileRepositoryProvider);
      return FindUserProfileByUsernameUseCase(repository);
    });

// Controller
final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, UserProfileState>((ref) {
      final createUserProfileUseCase = ref.watch(
        createUserProfileUseCaseProvider,
      );
      final updateUserProfileUseCase = ref.watch(
        updateUserProfileUseCaseProvider,
      );
      final deleteUserProfileUseCase = ref.watch(
        deleteUserProfileUseCaseProvider,
      );
      final findUserProfileUseCase = ref.watch(findUserProfileUseCaseProvider);
      final findUserProfileByUsernameUseCase = ref.watch(
        findUserProfileByUsernameUseCaseProvider,
      );

      return UserProfileController(
        ref: ref,
        createUserProfileUseCase: createUserProfileUseCase,
        updateUserProfileUseCase: updateUserProfileUseCase,
        deleteUserProfileUseCase: deleteUserProfileUseCase,
        findUserProfileUseCase: findUserProfileUseCase,
        findUserProfileByUsernameUseCase: findUserProfileByUsernameUseCase,
      );
    });
