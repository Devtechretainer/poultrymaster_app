import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/create_user_profile_usecase.dart';
import '../../domain/usecases/delete_user_profile_usecase.dart';
import '../../domain/usecases/find_user_profile_by_username_usecase.dart';
import '../../domain/usecases/find_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../providers/auth_providers.dart';
import '../states/user_profile_state.dart';

class UserProfileController extends StateNotifier<UserProfileState> {
  final CreateUserProfileUseCase createUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final DeleteUserProfileUseCase deleteUserProfileUseCase;
  final FindUserProfileUseCase findUserProfileUseCase;
  final FindUserProfileByUsernameUseCase findUserProfileByUsernameUseCase;
  final Ref ref;

  UserProfileController({
    required this.createUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.deleteUserProfileUseCase,
    required this.findUserProfileUseCase,
    required this.findUserProfileByUsernameUseCase,
    required this.ref,
  }) : super(const UserProfileState());

  Future<void> createUserProfile(UserProfile userProfile) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newUserProfile = await createUserProfileUseCase(userProfile);
      state = state.copyWith(isLoading: false, userProfile: newUserProfile);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedUserProfile = await updateUserProfileUseCase(userProfile);
      state = state.copyWith(isLoading: false, userProfile: updatedUserProfile);

      final authControllerNotifier = ref.read(authControllerProvider.notifier);
      final currentUser = ref.read(authControllerProvider).user;

      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          firstName: updatedUserProfile.firstName,
          lastName: updatedUserProfile.lastName,
          phoneNumber: updatedUserProfile.phoneNumber,
          farmName: updatedUserProfile.farmName,
          email: updatedUserProfile.email,
          username: updatedUserProfile.userName,
        );
        authControllerNotifier.updateUser(updatedUser);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteUserProfile(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await deleteUserProfileUseCase(id);
      state = state.copyWith(isLoading: false, userProfile: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> findUserProfile(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userProfile = await findUserProfileUseCase(id);
      state = state.copyWith(isLoading: false, userProfile: userProfile);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> findUserProfileByUsername(String normalizedUserName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userProfile =
          await findUserProfileByUsernameUseCase(normalizedUserName);
      state = state.copyWith(isLoading: false, userProfile: userProfile);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
