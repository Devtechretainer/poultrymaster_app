import 'package:dio/dio.dart';
import '../models/user_model.dart';

/// Data source - Handles authentication API calls
/// In a real app, this would make HTTP requests to your backend
class AuthDataSource {
  final Dio? dio;
  final String? baseUrl;

  AuthDataSource({this.dio, this.baseUrl});

  /// Login - Calls the real API
  /// Endpoint: POST /api/Authentication/login
  /// Request body: { "username": string, "password": string, "rememberMe": bool }
  Future<UserModel> login(
    String usernameOrEmail,
    String password,
    bool rememberMe,
  ) async {
    if (dio == null || baseUrl == null) {
      throw UnimplementedError(
        'Login API call not implemented. Dio and baseUrl must be provided.',
      );
    }

    try {
      final response = await dio!.post(
        '$baseUrl/api/Authentication/login',
        data: {
          'username': usernameOrEmail,
          'password': password,
          'rememberMe': rememberMe,
        },
        options: Options(
          headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
          followRedirects: true,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Handle different response formats
        Map<String, dynamic> responseData;
        if (data is Map<String, dynamic>) {
          responseData = data;
        } else {
          throw Exception('Invalid response format');
        }

        // Check if login was successful
        if (responseData['isSuccess'] == false) {
          final message =
              responseData['message'] as String? ??
              'Login failed. Please check your credentials.';
          throw Exception(message);
        }

        // Handle the API response structure
        // The API returns LoginResponse with ResponseData containing user info
        final responseObj = responseData['response'] as Map<String, dynamic>?;
        final accessToken =
            responseObj?['accessToken'] as Map<String, dynamic>?;
        final token = accessToken?['token'] as String?;

        // Extract user information from response
        final userId =
            responseData['userId'] as String? ??
            responseObj?['userId'] as String? ??
            '';
        final username =
            responseData['username'] as String? ??
            responseObj?['username'] as String? ??
            usernameOrEmail;
        final farmId =
            responseData['farmId'] as String? ??
            responseObj?['farmId'] as String? ??
            userId; // Fallback to userId if farmId not provided
        final farmName =
            responseData['farmName'] as String? ??
            responseObj?['farmName'] as String? ??
            '';

        return UserModel(
          id: userId,
          farmId: farmId,
          farmName: farmName.isNotEmpty ? farmName : 'My Farm',
          firstName: '', // Will be populated from user profile endpoint
          lastName: '', // Will be populated from user profile endpoint
          username: username,
          email: usernameOrEmail.contains('@') ? usernameOrEmail : '',
          phoneNumber: '', // Will be populated from user profile endpoint
          token: token,
        );
      } else if (response.statusCode == 401) {
        throw Exception('Invalid username or password');
      } else {
        final errorMsg =
            (response.data as Map<String, dynamic>?)?['message'] as String?;
        throw Exception(errorMsg ?? 'Login failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle network errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Cannot connect to server. Please ensure the API is running.',
        );
      } else if (e.response?.statusCode == 401) {
        throw Exception('Invalid username or password');
      } else if (e.response?.statusCode != null) {
        final errorMsg =
            (e.response?.data as Map<String, dynamic>?)?['message'] as String?;
        throw Exception(errorMsg ?? 'Login failed: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message ?? 'Unknown error'}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Login failed: $e');
    }
  }

  /// Register - In real app, this would call your API
  Future<UserModel> register({
    required String farmName,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    if (dio == null || baseUrl == null) {
      throw UnimplementedError(
        'Register API call not implemented. Dio and baseUrl must be provided.',
      );
    }

    try {
      final response = await dio!.post(
        '$baseUrl/api/Authentication/Register',
        data: {
          'farmName': farmName,
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final responseData = data['response'] as Map<String, dynamic>?;
        final accessToken =
            responseData?['accessToken'] as Map<String, dynamic>?;
        final token = accessToken?['token'] as String?;

        final userId =
            data['userId'] as String? ??
            responseData?['userId'] as String? ??
            '';
        final farmId =
            data['farmId'] as String? ??
            responseData?['farmId'] as String? ??
            userId;

        return UserModel(
          id: userId,
          farmId: farmId,
          farmName: farmName,
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          token: token,
        );
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorMessage = e.response?.data?['message'] as String?;
        throw Exception(errorMessage ?? 'Registration failed');
      }
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Request password reset OTP
  Future<void> requestPasswordReset(String email) async {
    if (dio == null || baseUrl == null) {
      throw UnimplementedError('Request OTP API call not implemented.');
    }

    try {
      await dio!.post(
        '$baseUrl/api/Authentication/forgot-password',
        data: {'email': email},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      throw Exception('Failed to request password reset: $e');
    }
  }

  /// Reset password with OTP
  Future<void> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    if (dio == null || baseUrl == null) {
      throw UnimplementedError('Reset password API call not implemented.');
    }

    try {
      await dio!.post(
        '$baseUrl/api/Authentication/reset-password',
        data: {'email': email, 'otp': otp, 'newPassword': newPassword},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }
}
