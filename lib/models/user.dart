import 'package:final_projesi/models/product.dart';

class UserModel {
  final String _id;
  final String _name;
  final String _lastName;
  final String _password;
  final String _email;
  List<Product> _sharedProductList;

  UserModel({
    required String id,
    required String name,
    required String lastName,
    required String password,
    required String email,
    List<Product>? sharedProductList,
  })  : _id = id,
        _name = name,
        _lastName = lastName,
        _password = password,
        _email = email,
        _sharedProductList = sharedProductList ?? [];

  // Getters
  String get id => _id;
  String get name => _name;
  String get lastName => _lastName;
  String get password => _password;
  String get email => _email;
  List<Product> get sharedProductList => _sharedProductList;

  // Firebase'den veri okuma
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      lastName: data['lastName'] ?? '',
      password: data['password'] ?? '',
      email: data['email'] ?? '',
      sharedProductList: (data['sharedProductList'] as List<dynamic>?)
          ?.map((item) => Product.fromMap(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  // Firebase'e veri yazma
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'lastName': _lastName,
      'password': _password,
      'email': _email,
      'sharedProductList': _sharedProductList.map((product) => product.toMap()).toList(),
    };
  }

  // Kullanıcının sharedProductList'ine yeni bir ürün ekleme
  void addProduct(Product product) {
    _sharedProductList.add(product);
  }

  // Kullanıcı tam adını döndürme (displayName için)
  String get displayName => '$_name $_lastName';
}
