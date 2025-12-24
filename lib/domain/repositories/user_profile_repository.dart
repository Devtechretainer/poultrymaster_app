import '../../domain/entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile> createUserProfile(UserProfile userProfile);
  Future<UserProfile> updateUserProfile(UserProfile userProfile);
  Future<void> deleteUserProfile(String id);
  Future<UserProfile> findUserProfile(String id);
  Future<UserProfile> findUserProfileByUsername(String normalizedUserName);
}
