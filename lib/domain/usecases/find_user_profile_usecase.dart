import '../../domain/entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

class FindUserProfileUseCase {
  final UserProfileRepository repository;

  FindUserProfileUseCase(this.repository);

  Future<UserProfile> call(String id) {
    if (id.isEmpty) {
      throw ArgumentError('User profile ID cannot be empty for find.');
    }
    return repository.findUserProfile(id);
  }
}
