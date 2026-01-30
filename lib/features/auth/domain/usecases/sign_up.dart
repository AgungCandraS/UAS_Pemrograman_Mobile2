import 'package:bisnisku/core/types/typedefs.dart';
import 'package:bisnisku/features/auth/domain/entities/user_profile.dart';
import 'package:bisnisku/features/auth/domain/repositories/auth_repository.dart';

/// Sign up use case
class SignUp {
  final AuthRepository _repository;

  SignUp(this._repository);

  FutureResult<UserProfile> call({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _repository.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}
