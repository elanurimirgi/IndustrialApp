import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_projesi/customWidgets/productCard.dart';

void main() {
  testWidgets('ProductCard displays correct product details', (WidgetTester tester) async {
    // Test için bir ProductCard widget'ı oluşturuyoruz
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductCard(
            productName: 'Test Product',
            productDate: '2024-12-19',
            productPrice: 100.0,
            category: 'Electronics',
            ownerMail: 'owner@example.com',
            documentUrl: 'https://example.com/document', // Opsiyonel alan
          ),
        ),
      ),
    );

    // Text widget'larının doğru şekilde görüntülendiğini kontrol ediyoruz
    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('2024-12-19'), findsOneWidget);
    expect(find.text('₺100.00'), findsOneWidget);
    expect(find.text('Electronics'), findsOneWidget);
    expect(find.text('Owner: owner@example.com'), findsOneWidget);

    // Opsiyonel linki kontrol edelim
    expect(find.text('Document: View'), findsOneWidget);

    // Card widget'ının düzgün render edildiğini kontrol ediyoruz
    expect(find.byType(Card), findsOneWidget);

    // GestureDetector ile link tıklamasını test edelim
    final gestureDetectorFinder = find.text('Document: View');
    expect(gestureDetectorFinder, findsOneWidget);

    // Simule ederek tıklama gerçekleştiriyoruz
    await tester.tap(gestureDetectorFinder);
    await tester.pump(); // Widget ağacını yeniden oluştur
  });
}
