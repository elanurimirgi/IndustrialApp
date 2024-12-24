import 'package:final_projesi/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String productDate;
  final double productPrice;
  final String category;
  final String ownerMail;
  final String? documentUrl;

  const ProductCard({
    Key? key,
    required this.productName,
    required this.productDate,
    required this.productPrice,
    required this.ownerMail,
    required this.category,
    this.documentUrl,
  }) : super(key: key);

  Future<void> _openDocument(BuildContext context, String url) async {
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error opening URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening document: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: kProductCardBoxDecoration,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              productDate,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "₺${productPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Owner: $ownerMail',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            if (documentUrl != null) ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _openDocument(context, documentUrl!),
                child: const Text(
                  'Document: View',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
