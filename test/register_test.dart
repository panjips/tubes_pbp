import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_slicing/presentations/screens/auth/registrasi_screen.dart';

void main() {
  testWidgets('Register success', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegistrasiScreen(),
      ),
    );

    await tester.pumpAndSettle();

    var usernameField = find.byKey(const Key('Username'));
    expect(usernameField, findsOneWidget);

    var passwordField = find.byKey(const Key('Password'));
    expect(passwordField, findsOneWidget);

    var emailField = find.byKey(const Key('Email'));
    expect(emailField, findsOneWidget);

    var firstNameField = find.byKey(const Key('FirstName'));
    expect(firstNameField, findsOneWidget);

    var lastNameField = find.byKey(const Key('LastName'));
    expect(lastNameField, findsOneWidget);

    var birthDateField = find.byKey(const Key('TanggalLahir'));
    expect(birthDateField, findsOneWidget);

    var jenisKelaminField = find.byKey(const Key('JenisKelamin'));
    expect(jenisKelaminField, findsOneWidget);

    var registerButton = find.byKey(const Key('RegisterButton'));
    expect(registerButton, findsOneWidget);

    await tester.enterText(usernameField, 'sakura');
    await tester.enterText(passwordField, '123456');
    await tester.enterText(emailField, 'sakura@gmail.com');
    await tester.enterText(firstNameField, 'Sakura');
    await tester.enterText(lastNameField, 'Haruno');
    await tester.pump();

    await tester.tap(birthDateField);
    await tester.tap(find.text('15'));
    await tester.tap(find.text('OK'));
    await tester.tap(jenisKelaminField);
    await tester.tap(find.text('Laki-Laki'));
    await tester.pump();

    await tester.tap(registerButton);
    await tester.pump();

    var dialog = find.byKey(const Key('Dialog'));
    expect(dialog, findsOneWidget);

    var yakinButton = find.byKey(const Key('DialogYakin'));
    expect(yakinButton, findsOneWidget);

    await tester.tap(yakinButton);

    await tester.pumpAndSettle();
    expect(find.byKey(const Key('LoginSuccess')), findsOneWidget);
  });
}
