import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/create_user_profile_usecase.dart';
import '../../domain/usecases/delete_user_profile_usecase.dart';
import '../../domain/usecases/find_user_profile_by_username_usecase.dart';
import '../../domain/usecases/find_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../states/user_profile_state.dart';

class UserProfileController extends StateNotifier<UserProfileState> {
  final CreateUserProfileUseCase createUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final DeleteUserProfileUseCase deleteUserProfileUseCase;
  final FindUserProfileUseCase findUserProfileUseCase;
  final FindUserProfileByUsernameUseCase findUserProfileByUsernameUseCase;

  UserProfileController({
    required this.createUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.deleteUserProfileUseCase,
    required this.findUserProfileUseCase,
    required this.findUserProfileByUsernameUseCase,
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
      final userProfile = await findUserProfileByUsernameUseCase(normalizedUserName);
      state = state.copyWith(isLoading: false, userProfile: userProfile);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
