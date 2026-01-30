import 'package:bisnisku/core/types/typedefs.dart';
import 'package:bisnisku/features/auth/domain/repositories/auth_repository.dart';

/// Sign out use case
class SignOut {
  final AuthRepository _repository;

  SignOut(this._repository);

  FutureResult<void> call() async {
    return await _repository.signOut();
  }
}
