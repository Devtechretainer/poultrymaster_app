import '../../domain/entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

class CreateUserProfileUseCase {
  final UserProfileRepository repository;

  CreateUserProfileUseCase(this.repository);

  Future<UserProfile> call(UserProfile userProfile) {
    // Add any validation logic here
    return repository.createUserProfile(userProfile);
  }
}
