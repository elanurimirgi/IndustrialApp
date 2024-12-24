import 'package:flutter_test/flutter_test.dart';
import 'package:final_projesi/models/user.dart';
import 'package:final_projesi/models/product.dart';

void main() {
  group('UserModel Tests', () {
    test('UserModel.fromMap correctly converts data from Firebase', () {
      // Arrange: Firebase'den alınan örnek bir veri
      final userData = {
        'id': 'user123',
        'name': 'John',
        'lastName': 'Doe',
        'password': 'password123',
        'email': 'john.doe@example.com',
        'sharedProductList': [
          {
            'productId': 'product123',
            'userId': 'user123',
            'ownerEmail': 'john.doe@example.com',
            'productName': 'Product 1',
            'description': 'This is product 1',
            'category': 'Electronics',
            'price': 99.99,
            'createdDate': '2024-12-19T00:00:00.000',
          }
        ]
      };

      // Act: Firebase'den gelen veriyi UserModel nesnesine dönüştür
      final user = UserModel.fromMap(userData);

      // Assert: Verilerin doğru şekilde dönüştürülüp dönüştürülmediğini kontrol et
      expect(user.id, 'user123');
      expect(user.name, 'John');
      expect(user.lastName, 'Doe');
      expect(user.password, 'password123');
      expect(user.email, 'john.doe@example.com');
      expect(user.sharedProductList.length, 1);
      expect(user.sharedProductList[0].productId, 'product123'); // getProductId yerine productId
    });

    test('UserModel.toMap correctly converts user to a map', () {
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
            createdDate: DateTime.parse('2024-12-19T00:00:00.000'),
          )
        ],
      );

      // Act: UserModel nesnesini Map formatına çeviriyoruz
      final userMap = user.toMap();

      // Assert: Map'in doğru veriler içerdiğini kontrol et
      expect(userMap['id'], 'user123');
      expect(userMap['name'], 'John');
      expect(userMap['lastName'], 'Doe');
      expect(userMap['password'], 'password123');
      expect(userMap['email'], 'john.doe@example.com');
      expect(userMap['sharedProductList'].length, 1);
      expect(userMap['sharedProductList'][0]['productId'], 'product123');
    });

    test('UserModel addProduct adds product to sharedProductList', () {
      // Arrange: Test için bir UserModel nesnesi oluşturuyoruz
      final user = UserModel(
        id: 'user123',
        name: 'John',
        lastName: 'Doe',
        password: 'password123',
        email: 'john.doe@example.com',
        sharedProductList: [],
      );

      final product = Product(
        productId: 'product456',
        userId: 'user123',
        ownerEmail: 'john.doe@example.com',
        productName: 'Product 2',
        description: 'This is product 2',
        category: 'Home',
        price: 49.99,
        createdDate: DateTime.now(),
      );

      // Act: Yeni ürün ekleniyor
      user.addProduct(product);

      // Assert: sharedProductList'e ürün eklenip eklenmediğini kontrol et
      expect(user.sharedProductList.length, 1);
      expect(user.sharedProductList[0].productId, 'product456'); // getProductId yerine productId
    });

    test('UserModel displayName returns correct full name', () {
      // Arrange: Test için bir UserModel nesnesi oluşturuyoruz
      final user = UserModel(
        id: 'user123',
        name: 'John',
        lastName: 'Doe',
        password: 'password123',
        email: 'john.doe@example.com',
        sharedProductList: [],
      );

      // Act & Assert: displayName getter'ının doğru çalışıp çalışmadığını kontrol et
      expect(user.displayName, 'John Doe');
    });
  });
}