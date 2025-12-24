import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_datasource.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileDataSource dataSource;

  UserProfileRepositoryImpl(this.dataSource);

  @override
  Future<UserProfile> createUserProfile(UserProfile userProfile) {
    return dataSource.createUserProfile(userProfile);
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile userProfile) {
    return dataSource.updateUserProfile(userProfile);
  }

  @override
  Future<void> deleteUserProfile(String id) {
    return dataSource.deleteUserProfile(id);
  }

  @override
  Future<UserProfile> findUserProfile(String id) {
    return dataSource.findUserProfile(id);
  }

  @override
  Future<UserProfile> findUserProfileByUsername(String normalizedUserName) {
    return dataSource.findUserProfileByUsername(normalizedUserName);
  }
}
