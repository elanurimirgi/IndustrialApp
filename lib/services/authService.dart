import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mevcut kullanıcıyı döndür (UserModel'e dönüştürerek)
  UserModel? get currentUser {
    final user = _auth.currentUser;
    return user != null
        ? UserModel.fromMap({
      'id': user.uid,
      'name': user.displayName ?? '', // Kullanıcının ismini al
      'email': user.email ?? '',
      'lastName': '', // Firebase'de soyad yoksa boş bırakılıyor
      'password': '', // Şifre bilgisi güvenlik için Firestore'da tutulmuyor
      'sharedProductList': [] // Varsayılan olarak boş liste
    })
        : null;
  }

  // Kullanıcının ürün paylaşım listesine ürün ekleme işlemi
  Future<void> addProductToSharedList(String userId, Product product) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        // Kullanıcıyı Firestore'dan al ve sharedProductList'i güncelle
        final userData = UserModel.fromMap(userSnapshot.data()!);

        // Ürünü mevcut listeye ekle
        userData.sharedProductList.add(product);

        // Firestore'da güncelle
        await userRef.update(userData.toMap());
      } else {
        throw Exception('Kullanıcı bulunamadı.');
      }
    } catch (e) {
      print("Error adding product to shared list: $e");
      // Gerekirse hata loglama veya UI için daha fazla işlem yapılabilir
    }
  }

  // Başvuru kaydetme işlemi
  Future<void> submitApplication({
    required String productId,
    required String userId,
    required String name,
    required String email,
  }) async {
    try {
      final collection = _firestore.collection('applications');
      await collection.add({
        'productId': productId,
        'userId': userId,
        'name': name,
        'email': email,
        'timestamp': FieldValue.serverTimestamp(), // Başvuru tarihi
      });
    } catch (e) {
      print("Error submitting application: $e");
      throw Exception('Başvuru kaydedilemedi: $e');
    }
  }

  // Belirli bir ürün için başvuranları al
  Future<List<UserModel>> getApplicants(String productId) async {
    try {
      // Firestore'dan başvuranları al
      final querySnapshot = await _firestore
          .collection('applications')
          .where('productId', isEqualTo: productId)
          .orderBy('timestamp', descending: true)
          .get();

      // Kullanıcı verilerini UserModel'e dönüştür
      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching applicants: $e");
      throw Exception('Başvuranlar alınırken hata oluştu: $e');
    }
  }
}
