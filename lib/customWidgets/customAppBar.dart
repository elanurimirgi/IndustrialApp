import 'package:final_projesi/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:final_projesi/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // Başlık metni
  final bool hasButton; // Geri düğmesinin olup olmadığını kontrol eder
  final List<Widget>? actions; // Ekstra aksiyonlar (butonlar) için

  const CustomAppBar({
    Key? key,
    this.title,
    this.hasButton = false,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: kAppBarBackgroundColor,
        ),
      ),
      leading: hasButton
          ? IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        icon: const Icon(
          Icons.arrow_back,
          size: 25,
        ),
      )
          : null,
      title: title != null
          ? Text(
        title!,
        style: kAppBarTittleTextStyle,
      )
          : null,
      actions: actions, // AppBar'ın sağ tarafına aksiyonlar eklenir
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
