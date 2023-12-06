import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_slicing/presentations/screens/auth/sign_in_screen.dart';

void main() {
  testWidgets('Berhasil Sign In', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SignInScreen(),
    ));
    await tester.pumpAndSettle();

    final usernameField = find.byKey(const Key('Username'));
    expect(usernameField, findsOneWidget);

    final passwordField = find.byKey(const Key('Password'));
    expect(passwordField, findsOneWidget);

    final buttonLogin = find.byKey(const Key('loginButton'));
    expect(buttonLogin, findsOneWidget);

    await tester.enterText(usernameField, 'trisna');
    await tester.enterText(passwordField, '123456');
    await tester.press(buttonLogin);

    await tester.pump();
  });

  testWidgets('Gagal Sign In', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SignInScreen(),
    ));
    await tester.pumpAndSettle();

    final usernameField = find.byKey(const Key('Username'));
    expect(usernameField, findsOneWidget);

    final passwordField = find.byKey(const Key('Password'));
    expect(passwordField, findsOneWidget);

    final buttonLogin = find.byKey(const Key('loginButton'));
    expect(buttonLogin, findsOneWidget);

    await tester.enterText(usernameField, 'trisnaaaa');
    await tester.enterText(passwordField, '126');
    await tester.press(buttonLogin);

    await tester.pump();
  });
}
