import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/errors/auth_failure_mapper.dart';
import '../../../core/utils/result.dart';
import 'auth_remote_data_source.dart';

abstract interface class AuthRepository {
  Stream<User?> get authStateChanges;

  User? get currentUser;

  Future<Result<User?>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Result<User?>> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<Result<User?>> signInWithGoogle();

  Future<Result<void>> sendPasswordResetEmail({required String email});

  Future<Result<void>> signOut();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<User?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  User? get currentUser => _remoteDataSource.currentUser;

  @override
  Future<Result<User?>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Success(credential.user);
    } catch (error) {
      return FailureResult(AuthFailureMapper.map(error));
    }
  }

  @override
  Future<Result<User?>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
      );
      return Success(credential.user);
    } catch (error) {
      return FailureResult(AuthFailureMapper.map(error));
    }
  }

  @override
  Future<Result<User?>> signInWithGoogle() async {
    try {
      final UserCredential credential = await _remoteDataSource
          .signInWithGoogle();
      return Success(credential.user);
    } catch (error) {
      return FailureResult(AuthFailureMapper.map(error));
    }
  }

  @override
  Future<Result<void>> sendPasswordResetEmail({required String email}) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email: email);
      return const Success(null);
    } catch (error) {
      return FailureResult(AuthFailureMapper.map(error));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Success(null);
    } catch (error) {
      return FailureResult(AuthFailureMapper.map(error));
    }
  }
}
