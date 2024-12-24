import 'package:flutter_test/flutter_test.dart';
import 'package:final_projesi/models/product.dart';

void main() {
  group('Product Class', () {
    test('Product.fromMap correctly converts data from Firebase', () {
      final productData = {
        'productId': '123',
        'userId': '456',
        'ownerEmail': 'owner@example.com',
        'productName': 'Test Product',
        'description': 'This is a test product.',
        'category': 'Electronics',
        'price': 100.0,
        'createdDate': '2024-12-19T00:00:00.000',
        'documentUrl': 'https://example.com/doc.pdf',
      };

      final product = Product.fromMap(productData);

      expect(product.productId, '123');
      expect(product.userId, '456');
      expect(product.ownerEmail, 'owner@example.com');
      expect(product.productName, 'Test Product');
      expect(product.description, 'This is a test product.');
      expect(product.category, 'Electronics');
      expect(product.price, 100.0);
      expect(product.createdDate, DateTime.parse('2024-12-19T00:00:00.000'));
      expect(product.documentUrl, 'https://example.com/doc.pdf');
    });

    test('Product.toMap correctly converts product to a map', () {
      final product = Product(
        productId: '123',
        userId: '456',
        ownerEmail: 'owner@example.com',
        productName: 'Test Product',
        description: 'This is a test product.',
        category: 'Electronics',
        price: 100.0,
        createdDate: DateTime(2024, 12, 19),
        documentUrl: 'https://example.com/doc.pdf',
      );

      final productMap = product.toMap();

      expect(productMap['productId'], '123');
      expect(productMap['userId'], '456');
      expect(productMap['ownerEmail'], 'owner@example.com');
      expect(productMap['productName'], 'Test Product');
      expect(productMap['description'], 'This is a test product.');
      expect(productMap['category'], 'Electronics');
      expect(productMap['price'], 100.0);
      expect(productMap['createdDate'], '2024-12-19T00:00:00.000');
      expect(productMap['documentUrl'], 'https://example.com/doc.pdf');
    });
  });
}
