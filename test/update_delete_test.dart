import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_slicing/presentations/screens/ulasan/tambah_ulasan_screen.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/presentations/screens/ulasan/ulasan_screen.dart';

void main() {
  testWidgets('Test Tambah Data', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: TambahUlasanScreen(),
      ),
    ));

    await tester.pumpAndSettle();

    final ratingBar = find.byType(RatingBar);
    final reviewField = find.byType(TextFormField);
    final postButton = find.byType(ElevatedButton);

    expect(ratingBar, findsOneWidget);
    expect(reviewField, findsOneWidget);
    expect(postButton, findsOneWidget);

    await tester.tap(ratingBar);
    await tester.pumpAndSettle();

    await tester.press(postButton);
    await tester.pumpAndSettle();

    await tester.enterText(reviewField, 'Updated Review');
    await tester.pumpAndSettle();
    });

   testWidgets('Test Read Data', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: UlasanScreen(),
        ),
      ));

      await tester.pumpAndSettle();

      final ratingBar = find.byType(RatingBar);
      final reviewField = find.byType(TextFormField);

      expect(ratingBar, findsOneWidget);
      expect(reviewField, findsOneWidget);

      final expectedText = 'Yah, kamu belum ada review';
      expect(find.text(expectedText), findsOneWidget);
    });

      testWidgets('Test Update Ulasan', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Material(
            child: TambahUlasanScreen(),
          ),
        ));

        await tester.pumpAndSettle();

        final ratingBar = find.byType(RatingBar);
        final reviewField = find.byType(TextFormField);
        final postButton = find.byType(ElevatedButton);

        expect(ratingBar, findsOneWidget);
        expect(reviewField, findsOneWidget);
        expect(postButton, findsOneWidget);

        await tester.tap(ratingBar);
        await tester.pumpAndSettle();

        await tester.press(postButton);
        await tester.pumpAndSettle();

        await tester.enterText(reviewField, 'Updated Review');

      });

      testWidgets('Test Delete Ulasan', (WidgetTester tester) async {
         Ulasan testUlasan = Ulasan();
         Size testSize = Size(100, 100); 
        await tester.pumpWidget(MaterialApp(
          home: Material(
            child: UlasanVerticalCard(
               size: testSize,
                ulasan: testUlasan,
            ),
          ),
        ));

        await tester.pumpAndSettle();

        final deleteButton = find.byType(TextButton);
        expect(deleteButton, findsOneWidget);

        await tester.press(deleteButton);
        await tester.pumpAndSettle();
      });

}
