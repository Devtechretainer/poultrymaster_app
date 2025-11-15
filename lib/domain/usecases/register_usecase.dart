import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case - Encapsulates business logic for registration
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> call({
    required String farmName,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    // Business rules: Validation
    if (farmName.trim().isEmpty) {
      throw ArgumentError('Farm name cannot be empty');
    }
    if (firstName.trim().isEmpty) {
      throw ArgumentError('First name cannot be empty');
    }
    if (lastName.trim().isEmpty) {
      throw ArgumentError('Last name cannot be empty');
    }
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }
    if (email.trim().isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }
    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }
    if (phoneNumber.trim().isEmpty) {
      throw ArgumentError('Phone number cannot be empty');
    }
    if (password.trim().isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }
    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    return repository.register(
      farmName: farmName.trim(),
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      username: username.trim(),
      email: email.trim(),
      phoneNumber: phoneNumber.trim(),
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
