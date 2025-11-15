import '../repositories/auth_repository.dart';

/// Use case - Encapsulates business logic for logout
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    return repository.logout();
  }
}
