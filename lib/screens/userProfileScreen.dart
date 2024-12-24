import 'package:final_projesi/screens/singInScreen.dart';
import 'package:final_projesi/screens/userDetailScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../constants.dart';
import '../customWidgets/widgets.dart';
import '../services/services.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _productCategoryController =
      TextEditingController();
  bool _isAdding = false;
  String _username = 'Loading...';
  String? _documentUrl;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      final username = await _firestoreService.getUsername(userId);
      if (mounted) {
        setState(() {
          _username = username ?? 'Unknown';
        });
      }
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _productDescriptionController.dispose();
    _productCategoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDocumentFromDrive() async {
    try {
      final GoogleSignIn googleSignIn =
          GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in cancelled.')),
        );
        return;
      }

      final authHeaders = await account.authHeaders;
      final client = AuthenticatedHttpClient(authHeaders, http.Client());
      final driveApi = drive.DriveApi(client);

      final fileList = await driveApi.files
          .list(q: "mimeType != 'application/vnd.google-apps.folder'");
      final files = fileList.files;

      if (files == null || files.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No files found in Google Drive.')),
        );
        return;
      }

      final selectedFile = await showDialog<drive.File>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Select a file from Google Drive'),
          children: files.map((file) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, file),
              child: Text(file.name ?? 'Unnamed file'),
            );
          }).toList(),
        ),
      );

      if (selectedFile != null) {
        setState(() {
          _documentUrl =
              "https://drive.google.com/file/d/${selectedFile.id}/view?usp=sharing";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected file: ${selectedFile.name}')),
        );
      }
    } catch (e) {
      print("Error selecting file from Google Drive: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting file from Google Drive: $e')),
      );
    }
  }

  Future<void> _addProduct() async {
    final userId = _authService.currentUser?.uid;
    final ownerEmail = _authService.currentUser?.email ?? '';
    final productName = _productNameController.text.trim();
    final productPrice =
        double.tryParse(_productPriceController.text.trim()) ?? 0.0;
    final productDescription = _productDescriptionController.text.trim();
    final productCategory = _productCategoryController.text.trim();

    // Zorunlu alanların kontrolü
    if (userId == null ||
        productName.isEmpty ||
        productPrice <= 0.0 ||
        productDescription.isEmpty ||
        productCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    setState(() {
      _isAdding = true;
    });

    try {
      await _firestoreService.addProduct(
        Product(
          productId: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          productName: productName,
          description: productDescription,
          category: productCategory,
          price: productPrice,
          createdDate: DateTime.now(),
          ownerEmail: ownerEmail,
          documentUrl: _documentUrl, // İsteğe bağlı doküman
        ),
      );

      _productNameController.clear();
      _productPriceController.clear();
      _productDescriptionController.clear();
      _productCategoryController.clear();
      setState(() {
        _documentUrl = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
    } catch (e) {
      print("Error adding product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product: $e')),
      );
    } finally {
      setState(() {
        _isAdding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasButton: true,
        title: 'Welcome ${capitalizeFirstLetter(_username)}',
      ),
      backgroundColor: kScaffoldBackgroundColor,
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: _firestoreService
                    .getUserProducts(_authService.currentUser?.uid ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products added yet.'));
                  }
                  final products = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    //physics: const NeverScrollableScrollPhysics(),
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
                              builder: (context) =>
                                  UserDetailScreen(product: product),
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
            const SizedBox(height: 10),
            TextField(
              controller: _productNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                labelText: 'Product Name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _productPriceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                labelText: 'Product Price',
                hintText: 'e.g., 19.99',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _productDescriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                labelText: 'Product Description',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _productCategoryController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                labelText: 'Product Category',
              ),
            ),
            const SizedBox(height: 10),
            CustomElevatedButton(
              onPressed: _selectDocumentFromDrive,
              buttonTittle: 'Select Document from Google Drive',
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CustomElevatedButton(
                    onPressed: _isAdding ? null : _addProduct,
                    buttonTittle: _isAdding ? 'Adding...' : 'Add',
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CustomElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SingInScreen()),
                        (route) => false,
                      );
                    },
                    buttonTittle: 'Logout',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }
}

class AuthenticatedHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner;

  AuthenticatedHttpClient(this._headers, this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}
