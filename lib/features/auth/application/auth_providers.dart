import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bisnisku/core/network/supabase_client.dart';
import 'package:bisnisku/features/auth/application/auth_controller.dart';
import 'package:bisnisku/features/auth/application/auth_state.dart';
import 'package:bisnisku/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:bisnisku/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bisnisku/features/auth/domain/repositories/auth_repository.dart';
import 'package:bisnisku/features/auth/domain/usecases/sign_in.dart';
import 'package:bisnisku/features/auth/domain/usecases/sign_up.dart';
import 'package:bisnisku/features/auth/domain/usecases/sign_out.dart';
import 'package:bisnisku/features/auth/domain/usecases/get_profile.dart';
import 'package:bisnisku/features/auth/domain/usecases/reset_password.dart';

// Data layer providers
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSourceImpl(client);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

// Use case providers
final signInUseCaseProvider = Provider<SignIn>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignIn(repository);
});

final signUpUseCaseProvider = Provider<SignUp>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUp(repository);
});

final signOutUseCaseProvider = Provider<SignOut>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOut(repository);
});

final getProfileUseCaseProvider = Provider<GetProfile>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetProfile(repository);
});

final resetPasswordUseCaseProvider = Provider<ResetPassword>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ResetPassword(repository);
});

// Controller provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      signIn: ref.watch(signInUseCaseProvider),
      signUp: ref.watch(signUpUseCaseProvider),
      signOut: ref.watch(signOutUseCaseProvider),
      getProfile: ref.watch(getProfileUseCaseProvider),
      resetPassword: ref.watch(resetPasswordUseCaseProvider),
    );
  },
);
