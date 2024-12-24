import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/models.dart';
import '../customWidgets/widgets.dart';
import '../services/authService.dart';

class DetailScreen extends StatefulWidget {
  final Product product; // Product model with attributes like productName, description, price, etc.

  const DetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // AuthService örneği oluşturuluyor
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: const CustomAppBar(hasButton: true, title: 'Detail Page'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'product name :${widget.product.productName}', // Ürün adı
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'product category :${widget.product.category}', // Ürün adı
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'owner: ${widget.product.ownerEmail}', // Ürün adı
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Ürün fiyatı
            Text(
              'price: \$${widget.product.price.toStringAsFixed(2)}', // Ürün fiyatı
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),
            // Ürün açıklaması
            Text(
              'Description:', // Açıklama başlığı
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description, // Ürün açıklaması
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            CustomElevatedButton(
              onPressed: () async {
                try {
                  final user = _authService.currentUser; // Şu anki kullanıcıyı al
                  if (user != null) {
                    await _authService.submitApplication(
                      productId: widget.product.productId,
                      userId: user.id,
                      name: user.name,
                      email: user.email,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Başvurunuz başarıyla gönderildi!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Giriş yapmalısınız.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Başvuru sırasında hata oluştu: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              buttonTittle: 'REQUEST',
            )
          ],
        ),
      ),
    );
  }
}
