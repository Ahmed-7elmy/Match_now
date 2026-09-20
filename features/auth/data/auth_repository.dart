import 'package:firebase_auth/firebase_auth.dart';

import 'auth_remote_data_source.dart';

abstract interface class AuthRepository {
  Stream<User?> get authStateChanges;
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<User?> get authStateChanges => _remoteDataSource.authStateChanges;
}
