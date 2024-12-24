import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_projesi/customWidgets/customAppBar.dart';

void main() {
  test('Test CustomAppBar constructor', () {
    // CustomAppBar'ın parametreleriyle bir örnek oluşturun
    final appBar = CustomAppBar(
      title: 'Test Title',
      hasButton: true,
    );

    // appBar'ın özelliklerini doğrulayın
    expect(appBar.title, isNotNull);
    expect(appBar.hasButton, isTrue);
  });

  test('Test CustomAppBar default hasButton', () {
    final appBar = CustomAppBar(
      title: 'Test Title',
    );

    // Varsayılan değerin false olduğunu doğrulayın
    expect(appBar.hasButton, isFalse);
  });
}
