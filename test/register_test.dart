import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_slicing/presentations/screens/auth/registrasi_screen.dart';

void main() {
  testWidgets('Register test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RegistrasiScreen(),
      ),
    );
    
    // Tunggu hingga widget terpump dan siap digunakan.
    await tester.pumpAndSettle();

    var usernameField = find.byKey(const Key('Username'));
    var passwordField = find.byKey(const Key('Password'));
    var emailField = find.byKey(const Key('Email'));
    var firstNameField = find.byKey(const Key('FirstName'));
    var lastNameField = find.byKey(const Key('LastName'));
    var birthDateField = find.byKey(const Key('BirthDate'));
    var jenisKelaminField = find.byKey(const Key('JenisKelamin'));
    var registerButton = find.byKey(const Key('registerButton'));

    await tester.enterText(usernameField, 'trisna');
    await tester.enterText(passwordField, '123456');
    await tester.enterText(emailField, 'trisnaaaa@gmail.com');
    await tester.enterText(firstNameField, 'Trisna');
    await tester.enterText(lastNameField, 'Ayu');
    await tester.tap(birthDateField);
    await tester.tap(find.text('15'));
    await tester.tap(find.text('OK'));
    await tester.tap(jenisKelaminField);
    await tester.tap(find.text('Perempuan'));

    await tester.tap(registerButton);

    // Tunggu hingga widget terpump dan siap digunakan setelah tap.
    await tester.pumpAndSettle();

    // Expect sesuai dengan kondisi yang diharapkan setelah Register berhasil.
    expect(find.text('Success!'), findsOneWidget);
  });

}