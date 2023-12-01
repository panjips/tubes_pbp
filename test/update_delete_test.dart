import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_slicing/presentations/screens/ulasan/tambah_ulasan_screen.dart';
import 'package:test_slicing/data/model/destinasi.dart'; // Updated import

void main() {
  testWidgets('Test Update Ulasan', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: TambahUlasanScreen(),
      ),
    ));

    await tester.pumpAndSettle();

    // Find the review text field
    final ratingBar = find.byType(RatingBar);
    final reviewField = find.widgetWithText(TextFormField, 'Review :');
    final postButton = find.byType(ElevatedButton);
    
    expect(ratingBar, findsOneWidget);
    expect(reviewField, findsOneWidget);
    expect(postButton, findsOneWidget);

    await tester.tap(ratingBar);
    await tester.pumpAndSettle();

    await tester.tap(postButton);
    await tester.pumpAndSettle();

    await tester.enterText(reviewField, 'Updated Review');
  });

  testWidgets('Test Delete Ulasan', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: TambahUlasanScreen(),
      ),
    ));

    await tester.pumpAndSettle();

    final deleteButton = find.byType(TextButton); // Replace FlatButton with your delete button type
    expect(deleteButton, findsOneWidget);

    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.text('Delete Review'), findsNothing);
  });
}
