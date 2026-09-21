import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/result.dart';
import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repository}) : super(const AuthInitial()) {
    on<AuthSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository repository;
  StreamSubscription<User?>? _authSubscription;

  Future<void> _onSubscriptionRequested(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authSubscription?.cancel();
    _authSubscription = repository.authStateChanges.listen(
      (User? user) => add(AuthUserChanged(user)),
    );
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    final User? user = event.user;
    if (user == null) {
      emit(const AuthUnauthenticated());
      return;
    }

    emit(AuthAuthenticated(user));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final Result<User?> result = await repository.signInWithEmail(
      email: event.email,
      password: event.password,
    );

    if (result case FailureResult<User?>(failure: final failure)) {
      emit(AuthFailure(failure));
    }
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final Result<User?> result = await repository.signUpWithEmail(
      email: event.email,
      password: event.password,
    );

    if (result case FailureResult<User?>(failure: final failure)) {
      emit(AuthFailure(failure));
    }
  }

  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final Result<User?> result = await repository.signInWithGoogle();

    if (result case FailureResult<User?>(failure: final failure)) {
      emit(AuthFailure(failure));
    }
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final Result<void> result = await repository.sendPasswordResetEmail(
      email: event.email,
    );

    switch (result) {
      case Success<void>():
        emit(const PasswordResetEmailSent());
      case FailureResult<void>(failure: final failure):
        emit(AuthFailure(failure));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final Result<void> result = await repository.signOut();
    if (result case FailureResult<void>(failure: final failure)) {
      emit(AuthFailure(failure));
    }
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}
