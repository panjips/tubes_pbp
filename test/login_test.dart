import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubes_pbp/presentations/screens/auth/sign_in_screen.dart';
import 'package:tubes_pbp/presentations/screens/home_screen.dart';
import 'package:tubes_pbp/presentations/screens/navigation.dart';
import 'dart:io';
import 'package:tubes_pbp/presentations/widgets/snackbar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => HttpOverrides.global = null);
  // testWidgets('Success Sign In', (tester) async {
  //   await tester.pumpWidget(const MaterialApp(
  //     home: SignInScreen(),
  //   ));
  //   await tester.pumpAndSettle();

  //   await tester.enterText(find.byKey(const Key('Username')), "simen");
  //   await tester.pumpAndSettle();
  //   await tester.enterText(find.byKey(const Key('Password')), "123456");
  //   await tester.pumpAndSettle();
  //   await tester.dragUntilVisible(find.byType(ElevatedButton).last,
  //       find.byType(SingleChildScrollView), const Offset(407.8, 592.7));
  //   await tester.pumpAndSettle(const Duration(seconds:5));
  //   // await tester.dragUntilVisible(find.text("Sign Up"),
  //   //     find.byType(SingleChildScrollView), const Offset(407.8, 592.7));
  //   await tester.pumpAndSettle();
  //   await tester.tap(find.byType(ElevatedButton).last);
  //   await tester.pumpAndSettle(const Duration(seconds: 5));
  //   expect(find.byType(Navigation), findsOneWidget);
  //   await tester.pumpAndSettle();
  // });

  testWidgets('Failed Sign In', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SignInScreen(),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('Username')), "simen");
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('Password')), "12345");
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(find.byType(ElevatedButton).last,
        find.byType(SingleChildScrollView), const Offset(407.8, 592.7));
    await tester.pumpAndSettle(const Duration(seconds:5));
    // await tester.dragUntilVisible(find.text("Sign Up"),
    //     find.byType(SingleChildScrollView), const Offset(407.8, 592.7));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton).last);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(SignInScreen), findsOneWidget);
    await tester.pumpAndSettle();
  });
}