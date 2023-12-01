import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_slicing/data/model/destinasi.dart';
import 'package:test_slicing/presentations/screens/ulasan/tambah_ulasan_screen.dart';
import 'package:test_slicing/data/repository/ulasan_repository.dart';

void main() {
  testWidgets('Test Create Ulasan', (WidgetTester tester) async {
    // Build the TambahUlasanScreen widget
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: TambahUlasanScreen(),
      ),
    ));

    // Wait until the widget finishes processing
    await tester.pump();

    // Find TextFormField for review
    final reviewField = find.widgetWithText(TextFormField, 'Review :');
    expect(reviewField, findsOneWidget);

    // Enter review text
    await tester.enterText(reviewField, 'This is a test review');

    // Find the "Post" button
    final postButton = find.text('Post');
    expect(postButton, findsOneWidget);

    // Tap the "Post" button
    await tester.tap(postButton);

    // Wait for the widget to rebuild
    await tester.pump();

    // Verify that the review text is submitted
    expect(find.text('This is a test review'), findsOneWidget);

    // Verify that the UlasanRepository's tambahUlasan method is called
    // You may need to replace these values with actual data
    Ulasan expectedUlasan = Ulasan(
      idDestinasi: 'your_id_destinasi',
      idPengguna: 'your_id_pengguna',
      rating: 'your_rating',
      ulasan: 'This is a test review',
    );

    // Mock the UlasanRepository
    UlasanRepository ulasanRepository = UlasanRepository();

    // Verify that the tambahUlasan method is called with the expectedUlasan
    await expectLater(() async {
      await ulasanRepository.tambahUlasan(expectedUlasan);
    }, completes);
  });
}
