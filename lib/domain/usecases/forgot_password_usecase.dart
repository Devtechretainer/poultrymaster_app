import '../repositories/auth_repository.dart';

/// Use case - Encapsulates business logic for password reset
class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> requestOtp(String email) async {
    if (email.trim().isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }
    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }

    return repository.requestPasswordReset(email.trim());
  }

  Future<void> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    if (email.trim().isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }
    if (otp.trim().isEmpty) {
      throw ArgumentError('OTP cannot be empty');
    }
    if (newPassword.trim().isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }
    if (newPassword.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    return repository.resetPassword(email.trim(), otp.trim(), newPassword);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
