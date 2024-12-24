class Product {
  final String productId;
  final String userId;
  final String productName;
  final String description;
  final String category;
  final double price;
  final DateTime createdDate;
  final String ownerEmail;
  final String? documentUrl; // Yeni özellik

  Product({
    required this.productId,
    required this.userId,
    required this.productName,
    required this.description,
    required this.category,
    required this.price,
    required this.createdDate,
    required this.ownerEmail,
    this.documentUrl, // Opsiyonel olarak tanımlandı
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'userId': userId,
      'productName': productName,
      'description': description,
      'category': category,
      'price': price,
      'createdDate': createdDate.toIso8601String(),
      'ownerEmail': ownerEmail,
      'documentUrl': documentUrl, // Firestore'a ekleniyor
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['productId'] ?? '',
      userId: map['userId'] ?? '',
      productName: map['productName'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      createdDate: DateTime.parse(map['createdDate'] ?? DateTime.now().toIso8601String()),
      ownerEmail: map['ownerEmail'] ?? '',
      documentUrl: map['documentUrl'], // Firestore'dan okunuyor
    );
  }
}
