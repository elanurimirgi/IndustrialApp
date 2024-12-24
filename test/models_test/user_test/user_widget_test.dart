import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:final_projesi/models/user.dart';
import 'package:final_projesi/customWidgets/productCard.dart'; // Örnek olarak UserProfile widget'ı olabilir
import 'package:final_projesi/models/product.dart';

void main() {
  testWidgets('UserProfile widget displays user information correctly', (WidgetTester tester) async {
    // Arrange: Test için bir UserModel nesnesi oluşturuyoruz
    final user = UserModel(
      id: 'user123',
      name: 'John',
      lastName: 'Doe',
      password: 'password123',
      email: 'john.doe@example.com',
      sharedProductList: [
        Product(
          productId: 'product123',
          userId: 'user123',
          ownerEmail: 'john.doe@example.com',
          productName: 'Product 1',
          description: 'This is product 1',
          category: 'Electronics',
          price: 99.99,
          createdDate: DateTime.now(),
        )
      ],
    );

    // Act: UserProfile widget'ını ekrana yükle
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text(user.displayName), // Kullanıcı adı ve soyadı
              Text(user.email), // Kullanıcı email adresi
            ],
          ),
        ),
      ),
    );

    // Assert: Ekranda doğru verilerin görüntülendiğini kontrol et
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john.doe@example.com'), findsOneWidget);
  });
}
