import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubes_pbp/presentations/screens/ulasan/tambah_ulasan_screen.dart';
import 'package:tubes_pbp/data/model/destinasi.dart';
import 'package:tubes_pbp/presentations/screens/ulasan/ulasan_screen.dart';

void main() {

    testWidgets('Test Update Ulasan', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Material(
          child: TambahUlasanScreen(),
        ),
      ));

      await tester.pumpAndSettle();

      final ratingBar = find.byType(RatingBar);
      final reviewField = find.widgetWithText(TextField, 'Review :');
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
  
    final ulasanData = Ulasan(
      idPengguna: 'user123',
      rating: '4',
      ulasan: 'Ini adalah ulasan pengguna',
    );

    await tester.pumpWidget(MaterialApp(
      home: UlasanVerticalCard(
        size: Size(300, 200), 
        ulasan: ulasanData,
      ),
    ));

    await tester.pumpAndSettle();

    final deleteButtonFinder = find.widgetWithText(TextButton, 'Delete');
    expect(deleteButtonFinder, findsOneWidget);

    final deleteButton = tester.widget<TextButton>(deleteButtonFinder);
    deleteButton.onPressed!(); 
  });





}
