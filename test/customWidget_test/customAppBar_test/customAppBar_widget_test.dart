import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_projesi/customWidgets/customAppBar.dart';

void main() {
  testWidgets('CustomAppBar test', (WidgetTester tester) async {
    // 1. Test: CustomAppBar başlık ve geri düğmesi ile render edilsin
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(
          title: 'Test Başlık',
          hasButton: true,
        ),
      ),
    ));

    // Başlık metninin görünürlüğünü kontrol et
    expect(find.text('Test Başlık'), findsOneWidget);

    // Geri düğmesinin olup olmadığını kontrol et
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // 2. Test: CustomAppBar aksiyonları ile render edilsin
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(
          title: 'Test Başlık',
          hasButton: true,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        ),
      ),
    ));

    // Aksiyon butonunun (örneğin, search butonu) görünürlüğünü kontrol et
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}