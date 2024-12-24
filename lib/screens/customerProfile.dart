import 'package:final_projesi/constants.dart';
import 'package:final_projesi/customWidgets/customAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../customWidgets/widgets.dart';
import '../models/models.dart';
import '../services/firestoreService.dart';
import '../services/services.dart';
import 'screens.dart';

class CustomerProfile extends StatefulWidget {
  final String applicantUserId;
  final String applicantUserName;

  const CustomerProfile(
      {super.key,
      required this.applicantUserId,
      required this.applicantUserName});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  late String _applicantUserName; // Güncellenebilir kullanıcı adı


  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    _applicantUserName = widget.applicantUserName; // Başlangıç değeri
    _loadUsername(); // Kullanıcı adını yükle
  }

  Future<void> _loadUsername() async {
    final userId = widget.applicantUserId;
    if (userId != null) {
      final username = await _firestoreService.getUsername(userId);
      if (mounted) {
        setState(() {
          _applicantUserName = username ?? 'Unknown';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = widget.applicantUserId;

    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: CustomAppBar(
        hasButton: true,
        title: '${capitalizeFirstLetter(_applicantUserName)} Profile',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: StreamBuilder<List<Product>>(
                stream: _firestoreService.getUserProducts(userId ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products added yet.'));
                  }
                  final products = snapshot.data!;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      // Firestore'dan alınan Timestamp'i DateTime'a dönüştürüp formatlıyoruz
                      final formattedDate = DateFormat('yyyy-MM-dd')
                          .format(product.createdDate.toLocal());
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                  product: products[
                                      index]), // Product parameterini DetailScreen'e göndermek
                            ),
                          );
                        },
                        child: ProductCard(
                          productName: products[index].productName,
                          productDate: formattedDate,
                          productPrice: products[index].price,
                          ownerMail: products[index].ownerEmail,
                          category: products[index].category,
                          documentUrl: product.documentUrl,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
