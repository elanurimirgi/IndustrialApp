import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Giriş yapan kullanıcının bilgilerini al
  User? get currentUser => _auth.currentUser;

  // Kullanıcı giriş yap
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'Kullanıcı bulunamadı. Lütfen tekrar deneyin.',
        );
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'Hatalı şifre. Lütfen şifrenizi kontrol edin.',
        );
      } else {
        throw FirebaseAuthException(
          code: e.code,
          message: 'Bir hata oluştu. Lütfen tekrar deneyin.',
        );
      }
    } catch (e) {
      print("Sign in error: $e");
      rethrow;
    }
  }

  // Kullanıcı oluştur ve Firestore'a kaydet
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Firestore veritabanına kullanıcıyı ekle
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'Bu e-posta adresi zaten kullanılıyor.',
        );
      } else if (e.code == 'weak-password') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'Şifreniz çok zayıf. Lütfen daha güçlü bir şifre seçin.',
        );
      } else {
        throw FirebaseAuthException(
          code: e.code,
          message: 'Bir hata oluştu. Lütfen tekrar deneyin.',
        );
      }
    } catch (e) {
      print("Sign up error: $e");
      rethrow;
    }
  }

  // Giriş yapan kullanıcı bilgilerini al
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Çıkış yap
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
