import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubes_pbp/presentations/screens/auth/sign_in_screen.dart';
import 'package:tubes_pbp/presentations/screens/home_screen.dart';
import 'package:tubes_pbp/presentations/screens/navigation.dart';
import 'package:tubes_pbp/presentations/screens/ulasan/ulasan_screen.dart';
import 'package:tubes_pbp/presentations/widgets/card_destination.dart';
import 'dart:io';
import 'package:tubes_pbp/presentations/widgets/snackbar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => HttpOverrides.global = null);
  testWidgets('Success Sign In', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SignInScreen(),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('Username')), "simen");
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('Password')), "123456");
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(find.byType(ElevatedButton).last,
        find.byType(SingleChildScrollView), const Offset(407.8, 592.7));
    await tester.pumpAndSettle(const Duration(seconds:5));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton).last);
    await tester.pumpAndSettle(const Duration(seconds: 7));
    // expect(find.byType(Navigation), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tester.tap(find.byType(CardDestination).first);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.dragUntilVisible(find.byKey(const Key("SeeMore")).last,
        find.byType(SingleChildScrollView), const Offset(240.0, 774.4));
    await tester.tap(find.byKey(const Key("SeeMore")));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.star).first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key("Review")), "Test Review");
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text("Simen Ngui Fen"), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Edit"));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key("Review")), "YAYAYAYAYA");
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text("YAYAYAYAYA"), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Delete"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text("YAYAYAYAYA"), findsNothing);
  });
}