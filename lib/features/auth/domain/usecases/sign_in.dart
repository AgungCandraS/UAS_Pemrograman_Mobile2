import 'package:bisnisku/core/types/typedefs.dart';
import 'package:bisnisku/features/auth/domain/entities/user_profile.dart';
import 'package:bisnisku/features/auth/domain/repositories/auth_repository.dart';

/// Sign in use case
class SignIn {
  final AuthRepository _repository;

  SignIn(this._repository);

  FutureResult<UserProfile> call({
    required String email,
    required String password,
  }) async {
    return await _repository.signIn(email: email, password: password);
  }
}

/// Sign in with Google use case
class SignInWithGoogle {
  final AuthRepository _repository;

  SignInWithGoogle(this._repository);

  FutureResult<UserProfile> call() async {
    return await _repository.signInWithGoogle();
  }
}
