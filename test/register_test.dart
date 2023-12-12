import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubes_pbp/presentations/screens/auth/registrasi_screen.dart';
import 'package:tubes_pbp/presentations/screens/auth/sign_in_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => HttpOverrides.global = null);
  testWidgets('Register success', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegistrasiScreen(),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('Email')), "sakura@gmail.com");
    await tester.pumpAndSettle();
    // expect(usernameField, findsOneWidget);

    await tester.enterText(find.byKey(const Key('Username')), "sakura");
    await tester.pumpAndSettle();
    // expect(passwordField, findsOneWidget);

    await tester.enterText(find.byKey(const Key('Password')), "123456");
    await tester.pumpAndSettle();
    // expect(emailField, findsOneWidget);

    await tester.enterText(find.byKey(const Key('FirstName')), "Sakura");
    await tester.pumpAndSettle();
    // expect(firstNameField, findsOneWidget);

    await tester.enterText(find.byKey(const Key('LastName')), "Haruno");
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
        find.byKey(const Key('JenisKelamin')),
        find.byType(SingleChildScrollView),
        const Offset(131.6, 595.0));
    // expect(lastNameField, findsOneWidget);

    await tester.tap(find.byIcon(Icons.calendar_month_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text("OK").last);
    await tester.pumpAndSettle();
    // expect(birthDateField, findsOneWidget);

    await tester.tap(find.byKey(const Key('JenisKelamin')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key("Perempuan")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('RegisterButton')));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // var jenisKelaminField = find.byKey(const Key('JenisKelamin'));
    // expect(jenisKelaminField, findsOneWidget);

    // var registerButton = find.byKey(const Key('RegisterButton'));
    // expect(registerButton, findsOneWidget);

    // await tester.enterText(usernameField, 'sakura');
    // await tester.enterText(passwordField, '123456');
    // await tester.enterText(emailField, 'sakura@gmail.com');
    // await tester.enterText(firstNameField, 'Sakura');
    // await tester.enterText(lastNameField, 'Haruno');
    // await tester.pump();

    // await tester.tap(birthDateField);
    // await tester.tap(find.text('15'));
    // await tester.tap(find.text('OK'));
    // await tester.tap(jenisKelaminField);
    // await tester.tap(find.text('Laki-Laki'));
    // await tester.pump();

    // await tester.tap(registerButton);
    // await tester.pump();

    // var dialog = find.byKey(const Key('Dialog'));
    // expect(dialog, findsOneWidget);
    await tester.tap(find.text("Yakin"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(SignInScreen), findsOneWidget);
    await tester.pumpAndSettle();
    // expect(yakinButton, findsOneWidget);

    // await tester.tap(yakinButton);

    // await tester.pumpAndSettle();
    // expect(find.byKey(const Key('LoginSuccess')), findsOneWidget);
  });
}
