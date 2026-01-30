import 'package:bisnisku/core/types/typedefs.dart';
import 'package:bisnisku/features/auth/domain/entities/user_profile.dart';
import 'package:bisnisku/features/auth/domain/repositories/auth_repository.dart';

/// Get profile use case
class GetProfile {
  final AuthRepository _repository;

  GetProfile(this._repository);

  FutureResult<UserProfile?> call() async {
    return await _repository.getCurrentUser();
  }
}
