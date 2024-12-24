import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_projesi/screens/customerProfile.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/models.dart';
import '../customWidgets/widgets.dart';
import '../services/authService.dart';
import '../models/user.dart';
import '../utils/authenticatedHttpClient.dart'; // AuthenticatedHttpClient dosyasını import ettik.
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class UserDetailScreen extends StatefulWidget {
  final Product product;

  const UserDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  List<UserModel> applicants = [];
  String? _documentUrl;

  @override
  void initState() {
    super.initState();
    _loadApplicants(); // Load applicants when the screen initializes
  }

  Future<void> _loadApplicants() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final collection = FirebaseFirestore.instance.collection('applications');
      final querySnapshot = await collection
          .where('productId', isEqualTo: widget.product.productId)
          .orderBy('timestamp', descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // No applicants found
        setState(() {
          applicants = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Henüz bu tedarik için başvuru yapılmamış.'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        setState(() {
          applicants = querySnapshot.docs.map((doc) {
            final data = doc.data();
            return UserModel(
              id: data['userId'] ?? '',
              name: data['name'] ?? '',
              lastName: data['lastname'] ?? '',
              password: data['password'] ?? '',
              email: data['email'] ?? '',
            );
          }).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Başvurular yüklenirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

      final fileList = await driveApi.files.list(
          q: "mimeType != 'application/vnd.google-apps.folder'");
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

        // Firestore'da ürün bilgilerini güncelle
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.product.productId)
            .update({'documentUrl': _documentUrl});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Belge seçildi: ${selectedFile.name}')),
        );
      }
    } catch (e) {
      print("Error selecting file from Google Drive: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Belge seçilirken hata oluştu: $e')),
      );
    }
  }

  void _updateProduct() {
    Navigator.pushNamed(context, '/updateProduct', arguments: widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: CustomAppBar(
        hasButton: true,
        title: 'Supply Detail',
        actions: [
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: _selectDocumentFromDrive, // Belge seçme işlemi
            tooltip: 'Belge Ekle',
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _updateProduct, // Ürün güncelleme
            tooltip: 'Update Product',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.productName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'category: ${widget.product.category}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              'Açıklama:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Başvuranlar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : applicants.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: applicants.length,
                itemBuilder: (context, index) {
                  final applicant = applicants[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(applicant.name),
                    subtitle: Text(applicant.email),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerProfile(
                            applicantUserId: applicant.id,
                            applicantUserName: applicant.name,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
                : const Text('Henüz bu tedarik için başvuru yapılmamış.'),
          ],
        ),
      ),
    );
  }
}
