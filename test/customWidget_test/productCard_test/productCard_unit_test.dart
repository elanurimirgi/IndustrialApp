import 'package:flutter_test/flutter_test.dart';
import 'package:final_projesi/customWidgets/productCard.dart';

void main() {
  test('ProductCard displays correct product details', () {
    // ProductCard widget'ını test ortamında başlatıyoruz
    const productCard = ProductCard(
      productName: 'Test Product',
      productDate: '2024-12-19',
      productPrice: 100.0,
      category: 'Electronics',
      ownerMail: 'owner@example.com',
    );

    // Widget'ı oluşturup, parametrelerin doğru şekilde kullanıldığını test ediyoruz
    expect(productCard.productName, 'Test Product');
    expect(productCard.productDate, '2024-12-19');
    expect(productCard.productPrice, 100.0);
    expect(productCard.category, 'Electronics');
    expect(productCard.ownerMail, 'owner@example.com');
  });
}
