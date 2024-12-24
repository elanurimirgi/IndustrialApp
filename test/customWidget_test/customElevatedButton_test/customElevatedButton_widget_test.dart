import 'package:flutter_test/flutter_test.dart';
import 'package:final_projesi/customWidgets/customElevatedButton.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('CustomElevatedButton displays correct title and triggers onPressed', (WidgetTester tester) async {
    // 'isPressed' değişkenini kontrol etmek için bir callback fonksiyonu oluşturuyoruz
    bool isPressed = false;

    // CustomElevatedButton widget'ını test ortamına ekliyoruz
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomElevatedButton(
            onPressed: () {
              isPressed = true;
            },
            buttonTittle: 'Test Button',
          ),
        ),
      ),
    );

    // Butonun doğru başlığı görüntülediğini kontrol ediyoruz
    expect(find.text('TEST BUTTON'), findsOneWidget);

    // Butona tıklıyoruz
    await tester.tap(find.byType(ElevatedButton));

    // Yeni durumun doğru olup olmadığını kontrol ediyoruz
    expect(isPressed, true);
  });
}
