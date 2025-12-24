import '../repositories/user_profile_repository.dart';

class DeleteUserProfileUseCase {
  final UserProfileRepository repository;

  DeleteUserProfileUseCase(this.repository);

  Future<void> call(String id) {
    if (id.isEmpty) {
      throw ArgumentError('User profile ID cannot be empty for delete.');
    }
    return repository.deleteUserProfile(id);
  }
}
