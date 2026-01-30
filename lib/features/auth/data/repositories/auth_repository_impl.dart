import 'package:dartz/dartz.dart';
import 'package:bisnisku/core/errors/error_mapper.dart';
import 'package:bisnisku/core/types/typedefs.dart';
import 'package:bisnisku/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:bisnisku/features/auth/domain/entities/user_profile.dart';
import 'package:bisnisku/features/auth/domain/repositories/auth_repository.dart';

/// Auth repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  FutureResult<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(user.toEntity());
    } on Exception catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    }
  }

  @override
  FutureResult<UserProfile> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final user = await _remoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      return Right(user.toEntity());
    } on Exception catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    }
  }

  @override
  FutureResult<UserProfile> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      return Right(user.toEntity());
    } on Exception catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    }
  }

  @override
  FutureResult<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    }
  }

  @override
  FutureResult<UserProfile?> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user?.toEntity());
    } on Exception catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    }
  }

  @override
  FutureResult<void> resetPassword({required String email}) async {
    try {
      await _remoteDataSource.resetPassword(email: email);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    }
  }

  @override
  FutureResult<UserProfile> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      final user = await _remoteDataSource.updateProfile(
        userId: userId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
      );
      return Right(user.toEntity());
    } on Exception catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    }
  }

  @override
  bool isAuthenticated() {
    // This would check if there's a valid session
    return false; // Implement proper check
  }
}
