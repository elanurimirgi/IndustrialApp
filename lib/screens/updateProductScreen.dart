import 'package:final_projesi/screens/userProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore için gerekli paket
import '../customWidgets/widgets.dart';
import '../models/models.dart'; // Modelin bulunduğu dosya

class UpdateProductScreen extends StatefulWidget {
  final Product product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _productName;
  late String _description;
  late double _price;
  late String _category;

  @override
  void initState() {
    super.initState();
    _category = widget.product.category;
    _productName = widget.product.productName;
    _description = widget.product.description;
    _price = widget.product.price;
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Firestore'da ürün güncelleme
        await FirebaseFirestore.instance
            .collection('products') // Koleksiyon adı
            .doc(widget.product.productId) // Belge kimliği
            .update({
          'productName': _productName,
          'description': _description,
          'price': _price,
          'category': _category,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ürün başarıyla güncellendi!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserProfileScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Güncelleme sırasında bir hata oluştu: $e')),
        );
      }
    }
  }

  void _removeProduct() async {
    try {
      // Firestore'da ürün silme
      await FirebaseFirestore.instance
          .collection('products') // Koleksiyon adı
          .doc(widget.product.productId) // Belge kimliği
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün başarıyla silindi!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserProfileScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silme sırasında bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        hasButton: true,
        title: 'Update Product',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _productName,
                decoration: const InputDecoration(
                  labelText: 'Ürün Adı',
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSaved: (value) => _productName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Bu alan zorunludur.' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSaved: (value) => _description = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Bu alan zorunludur.' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(
                  labelText: 'Fiyat',
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => _price = double.parse(value!),
                validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null
                        ? 'Geçerli bir fiyat girin.'
                        : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSaved: (value) => _category = value!,
                validator: (value) =>
                value!.isEmpty ? 'Bu alan zorunludur.' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CustomElevatedButton(
                    onPressed: _saveProduct,
                    buttonTittle: 'Save',
                  ),
                  SizedBox(width: 80),
                  CustomElevatedButton(
                    onPressed: _removeProduct,
                    buttonTittle: 'remove',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
