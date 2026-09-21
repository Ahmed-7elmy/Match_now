import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'failures.dart';

class AuthFailureMapper {
  AuthFailureMapper._();

  static Failure map(Object error) {
    if (error is FirebaseAuthException) {
      return _mapFirebaseException(error);
    }

    if (error is GoogleSignInException) {
      return _mapGoogleException(error);
    }

    return const UnknownFailure('Authentication failed. Please try again.');
  }

  static Failure _mapFirebaseException(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return const UnauthorizedFailure('Please enter a valid email address.');
      case 'weak-password':
        return const UnauthorizedFailure('Your password is too weak.');
      case 'email-already-in-use':
        return const UnauthorizedFailure(
          'An account already exists with this email.',
        );
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return const UnauthorizedFailure('Incorrect email or password.');
      case 'user-disabled':
        return const UnauthorizedFailure('This account has been disabled.');
      case 'too-many-requests':
        return const RateLimitFailure(
          'Too many attempts. Please try again later.',
        );
      case 'network-request-failed':
        return const NetworkFailure();
      case 'google-id-token-missing':
        return const UnauthorizedFailure('Google authentication failed.');
      case 'google-web-not-configured':
        return const UnauthorizedFailure(
          'Google sign-in is not configured for web.',
        );
      default:
        return UnknownFailure(error.message ?? 'Authentication failed.');
    }
  }

  static Failure _mapGoogleException(GoogleSignInException error) {
    switch (error.code) {
      case GoogleSignInExceptionCode.canceled:
        return const UnauthorizedFailure('Google sign-in was cancelled.');
      case GoogleSignInExceptionCode.clientConfigurationError:
      case GoogleSignInExceptionCode.providerConfigurationError:
        return const UnauthorizedFailure(
          'Google sign-in is not configured correctly.',
        );
      default:
        return const UnknownFailure('Google sign-in failed.');
    }
  }
}
