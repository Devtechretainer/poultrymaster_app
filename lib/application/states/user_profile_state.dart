import '../../domain/entities/user_profile.dart';

class UserProfileState {
  final UserProfile? userProfile;
  final bool isLoading;
  final String? error;

  const UserProfileState({
    this.userProfile,
    this.isLoading = false,
    this.error,
  });

  UserProfileState copyWith({
    UserProfile? userProfile,
    bool? isLoading,
    String? error,
  }) {
    return UserProfileState(
      userProfile: userProfile ?? this.userProfile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
