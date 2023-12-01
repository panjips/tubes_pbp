import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_slicing/presentations/screens/auth/sign_in_screen.dart';
import 'package:test_slicing/presentations/widgets/auth_button.dart';

void main() {
  testWidgets('Sign in screen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SignInScreen(),
    ));

    // expect(find.byType(SignInScreen), findsOneWidget);
    // expect(find.byType(Image), findsOneWidget);
    // expect(find.byType(Text), findsNWidgets(5));
    // expect(find.byType(TextFormField), findsNWidgets(2));

    // final SignInScreenState signInScreenState =
    //     tester.state(find.byType(SignInScreen));

    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);

    await tester.enterText(find.byKey(ValueKey('Username')), 'trisna');
    await tester.enterText(find.byKey(ValueKey('Password')), '123456');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await tester.press(find.text('Sign in'));
    // await tester.tap(find.text('AuthButton'));
    // // expect(find.byType(GoogleButton), findsOneWidget);
  });
}
