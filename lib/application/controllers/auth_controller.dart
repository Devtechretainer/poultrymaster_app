import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/entities/user.dart';
import '../states/auth_state.dart';

/// Controller - Manages authentication state and coordinates use cases
class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository authRepository;

  AuthController({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
    required this.logoutUseCase,
    required this.authRepository,
  }) : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await authRepository.getCurrentUser();
        state = state.copyWith(user: user, isLoggedIn: user != null);
      }
    } catch (e) {
      // Ignore errors on startup check
    }
  }

  /// Login
  Future<void> login(
    String usernameOrEmail,
    String password,
    bool rememberMe,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await loginUseCase(usernameOrEmail, password, rememberMe);
      if (kDebugMode) {
        debugPrint('Logged in user phone number: ${user.phoneNumber}');
      }
      state = state.copyWith(
        user: user,
        isLoading: false,
        isLoggedIn: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Register
  Future<void> register({
    required String farmName,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await registerUseCase(
        farmName: farmName,
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      state = state.copyWith(
        user: user,
        isLoading: false,
        isLoggedIn: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Request password reset OTP
  Future<void> requestPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await forgotPasswordUseCase.requestOtp(email);
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Reset password with OTP
  Future<void> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await forgotPasswordUseCase.resetPassword(email, otp, newPassword);
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await logoutUseCase();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Update user data in the state
  void updateUser(User user) {
    state = state.copyWith(user: user);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}
