import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/user.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı ekleme
  Future<void> addUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  // Ürün ekleme
  Future<void> addProduct(Product product) async {
    await _firestore
        .collection('products')
        .doc(product.productId)
        .set(product.toMap());
  }

  // Tüm ürünleri alma
  Stream<List<Product>> getAllProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
    });
  }

  // Belirli kullanıcının ürünlerini alma
  Stream<List<Product>> getUserProducts(String userId) {
    return _firestore
        .collection('products')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
    });
  }

  // Kullanıcı adını alma
  Future<String?> getUsername(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data()?['username'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
  }
}
