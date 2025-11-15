import '../entities/user.dart';

/// Repository interface - Defines contract for authentication operations
abstract class AuthRepository {
  /// Login with username/email, password, and rememberMe flag
  Future<User> login(String usernameOrEmail, String password, bool rememberMe);

  /// Register a new user
  Future<User> register({
    required String farmName,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  });

  /// Request password reset OTP
  Future<void> requestPasswordReset(String email);

  /// Verify OTP and reset password
  Future<void> resetPassword(String email, String otp, String newPassword);

  /// Logout current user
  Future<void> logout();

  /// Get current user (from cache/storage)
  Future<User?> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}
