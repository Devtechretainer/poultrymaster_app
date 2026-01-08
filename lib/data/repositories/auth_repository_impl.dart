import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';

/// Repository implementation - Coordinates data sources
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;
  static const String _currentUserKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  // Public static getter for _currentUserKey
  static String get currentUserKey => _currentUserKey;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<User> login(
    String usernameOrEmail,
    String password,
    bool rememberMe,
  ) async {
    try {
      // In real app, this would call your API through dataSource
      final userModel = await dataSource.login(
        usernameOrEmail,
        password,
        rememberMe,
      );
      final user = userModel.toEntity();

      // Save user to local storage
      await _saveCurrentUser(user);

      return user;
    } catch (e) {
      // For demo purposes, create a mock user if API is not implemented
      // Remove this in production when you have a real API
      if (e is UnimplementedError) {
        // Mock login for demo - replace with actual API call
        final userId = DateTime.now().millisecondsSinceEpoch.toString();
        final mockUser = User(
          id: userId,
          farmId: userId, // Use user ID as farm ID for mock
          farmName: 'Demo Farm',
          firstName: 'John',
          lastName: 'Doe',
          username: usernameOrEmail.contains('@')
              ? 'demo_user'
              : usernameOrEmail,
          email: usernameOrEmail.contains('@')
              ? usernameOrEmail
              : 'demo@example.com',
          phoneNumber: '+1234567890',
          token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        );
        await _saveCurrentUser(mockUser);
        return mockUser;
      }
      rethrow;
    }
  }

  @override
  Future<User> register({
    required String farmName,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final userModel = await dataSource.register(
        farmName: farmName,
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      final user = userModel.toEntity();
      await _saveCurrentUser(user);
      return user;
    } catch (e) {
      // Mock registration for demo
      if (e is UnimplementedError) {
        final userId = DateTime.now().millisecondsSinceEpoch.toString();
        final mockUser = User(
          id: userId,
          farmId: userId, // Use user ID as farm ID for mock
          farmName: farmName,
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        );
        await _saveCurrentUser(mockUser);
        return mockUser;
      }
      rethrow;
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    return dataSource.requestPasswordReset(email);
  }

  @override
  Future<void> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    return dataSource.resetPassword(email, otp, newPassword);
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  @override
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson == null) return null;

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final userModel = UserModel.fromJson(userMap);
      return userModel.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> _saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userModel = UserModel.fromEntity(user);
    final userJson = jsonEncode(userModel.toJson());
    await prefs.setString(_currentUserKey, userJson);
    await prefs.setBool(_isLoggedInKey, true);
  }
}
