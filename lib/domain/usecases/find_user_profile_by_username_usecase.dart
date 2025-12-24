import '../../domain/entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

class FindUserProfileByUsernameUseCase {
  final UserProfileRepository repository;

  FindUserProfileByUsernameUseCase(this.repository);

  Future<UserProfile> call(String normalizedUserName) {
    if (normalizedUserName.isEmpty) {
      throw ArgumentError('Normalized username cannot be empty for find.');
    }
    return repository.findUserProfileByUsername(normalizedUserName);
  }
}
