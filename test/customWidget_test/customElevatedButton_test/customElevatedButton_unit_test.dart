import 'package:flutter_test/flutter_test.dart';
import 'package:final_projesi/customWidgets/customElevatedButton.dart';
import 'package:flutter/material.dart';

void main() {
  test('CustomElevatedButton onPressed callback is triggered', () {
    // 'onPressed' callback'ını test etmek için bir değişken oluşturuyoruz
    bool isPressed = false;

    // CustomElevatedButton widget'ını test ortamına ekliyoruz
    final widget = CustomElevatedButton(
      onPressed: () {
        isPressed = true;
      },
      buttonTittle: 'Test Button',
    );

    // Butona basıldığında onPressed'in tetiklenmesini bekliyoruz
    widget.onPressed?.call();

    // Sonuç olarak 'isPressed' değişkeninin true olmasını bekliyoruz
    expect(isPressed, true);
  });
}
