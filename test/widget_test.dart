import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eyego_project/app.dart';
import 'package:eyego_project/core/errors/failures.dart';
import 'package:eyego_project/core/utils/result.dart';
import 'package:eyego_project/features/auth/data/auth_repository.dart';

class _UnauthenticatedAuthRepository implements AuthRepository {
  @override
  Stream<User?> get authStateChanges => const Stream<User?>.empty();

  @override
  User? get currentUser => null;

  @override
  Future<Result<User?>> signInWithEmail({
    required String email,
    required String password,
  }) async => const FailureResult<User?>(UnauthorizedFailure());

  @override
  Future<Result<User?>> signInWithGoogle() async =>
      const FailureResult<User?>(UnauthorizedFailure());

  @override
  Future<Result<void>> signOut() async => const Success<void>(null);

  @override
  Future<Result<User?>> signUpWithEmail({
    required String email,
    required String password,
  }) async => const FailureResult<User?>(UnauthorizedFailure());

  @override
  Future<Result<void>> sendPasswordResetEmail({required String email}) async =>
      const Success<void>(null);
}

class _AuthenticatedAuthRepository extends _UnauthenticatedAuthRepository {
  @override
  Stream<User?> get authStateChanges => Stream<User?>.value(_TestUser());

  @override
  User? get currentUser => _TestUser();
}

class _TestUser extends Fake implements User {
  @override
  String? get email => 'test@eyego.dev';
}

void main() {
  testWidgets('shows the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      EyeGoApp(authRepository: _UnauthenticatedAuthRepository()),
    );

    expect(find.text('Match point ;)'), findsOneWidget);
  });

  testWidgets('Home Profile action navigates to Profile', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      EyeGoApp(authRepository: _AuthenticatedAuthRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your football home'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Your football home'), findsOneWidget);
  });

  testWidgets('Home Matches action navigates to Matches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      EyeGoApp(authRepository: _AuthenticatedAuthRepository()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Matches'));
    await tester.pump();

    expect(find.text('Matches'), findsOneWidget);
  });
}
