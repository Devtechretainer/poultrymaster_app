import '../../domain/entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

class UpdateUserProfileUseCase {
  final UserProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<UserProfile> call(UserProfile userProfile) {
    // Add any validation logic here
    if (userProfile.id == null || userProfile.id!.isEmpty) {
      throw ArgumentError('User profile ID cannot be empty for update.');
    }
    return repository.updateUserProfile(userProfile);
  }
}
