import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case - Encapsulates business logic for login
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(
    String usernameOrEmail,
    String password,
    bool rememberMe,
  ) async {
    // Business rule: Username/email cannot be empty
    if (usernameOrEmail.trim().isEmpty) {
      throw ArgumentError('Username or email cannot be empty');
    }

    // Business rule: Password cannot be empty
    if (password.trim().isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }

    // Business rule: Password must be at least 6 characters
    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    return repository.login(usernameOrEmail.trim(), password, rememberMe);
  }
}
