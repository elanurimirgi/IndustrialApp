import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firestoreService.dart';
import '../models/product.dart';
import '../constants.dart';
import 'detailScreen.dart';
import '../customWidgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: CustomAppBar(hasButton: false, title: 'Ürünler'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Arama çubuğu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: kSearchTextFieldBoxDecoration,
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: kSearchTextFieldInputDecoration,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: _firestoreService.getAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Ürün bulunamadı.'));
                  }

                  final products = snapshot.data!
                      .where((product) => product.productName
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()))
                      .toList();

                  if (products.isEmpty) {
                    return const Center(
                      child: Text('Aramanıza uygun ürün bulunamadı.'),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 3 / 4, // Kartların oranı
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final formattedDate = DateFormat('yyyy-MM-dd')
                          .format(product.createdDate.toLocal());

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(product: product),
                            ),
                          );
                        },
                        child: ProductCard(
                          productName: product.productName,
                          productDate: formattedDate,
                          productPrice: product.price,
                          ownerMail: product.ownerEmail,
                          category: product.category,
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
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
