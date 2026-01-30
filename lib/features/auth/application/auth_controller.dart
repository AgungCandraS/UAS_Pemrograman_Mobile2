import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bisnisku/features/auth/application/auth_state.dart';
import 'package:bisnisku/features/auth/domain/usecases/sign_in.dart';
import 'package:bisnisku/features/auth/domain/usecases/sign_up.dart';
import 'package:bisnisku/features/auth/domain/usecases/sign_out.dart';
import 'package:bisnisku/features/auth/domain/usecases/get_profile.dart';
import 'package:bisnisku/features/auth/domain/usecases/reset_password.dart';

/// Auth controller
class AuthController extends StateNotifier<AuthState> {
  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;
  final GetProfile _getProfile;
  final ResetPassword _resetPassword;

  AuthController({
    required SignIn signIn,
    required SignUp signUp,
    required SignOut signOut,
    required GetProfile getProfile,
    required ResetPassword resetPassword,
  }) : _signIn = signIn,
       _signUp = signUp,
       _signOut = signOut,
       _getProfile = getProfile,
       _resetPassword = resetPassword,
       super(AuthState.initial());

  /// Sign in
  Future<void> signIn({required String email, required String password}) async {
    state = AuthState.loading();

    final result = await _signIn(email: email, password: password);

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Sign up
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = AuthState.loading();

    final result = await _signUp(
      email: email,
      password: password,
      fullName: fullName,
    );

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Sign out
  Future<void> signOut() async {
    state = AuthState.loading();

    final result = await _signOut();

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = AuthState.unauthenticated(),
    );
  }

  /// Get current user
  Future<void> getCurrentUser() async {
    state = AuthState.loading();

    final result = await _getProfile();

    result.fold((failure) => state = AuthState.error(failure.message), (user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.unauthenticated();
      }
    });
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    state = AuthState.loading();

    final result = await _resetPassword(email: email);

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = AuthState.unauthenticated(),
    );
  }
}
