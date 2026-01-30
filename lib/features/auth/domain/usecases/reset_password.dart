import 'package:bisnisku/core/types/typedefs.dart';
import 'package:bisnisku/features/auth/domain/repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository _repository;

  ResetPassword(this._repository);

  Future<Result<void>> call({required String email}) async {
    return await _repository.resetPassword(email: email);
  }
}
