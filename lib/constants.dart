import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final TextStyle kAppBarTittleTextStyle = GoogleFonts.pacifico(
  color: Colors.black,
);

const Color kScaffoldBackgroundColor = Color(0xFFF2B5B5);
const Color kAppBarBackgroundColor = Color(0xFFF2B5B5);
const Color kElevatedButtonBackgroundColor = Color(0xFF79747E);
const Color kElevatedButtonForegroundColor = Colors.white;

final BoxDecoration kSingFormDecoration = BoxDecoration(
  color: const Color(0xFFC3B7B7), // Kutunun arka plan rengi
  borderRadius: BorderRadius.circular(15), // Yuvarlatılmış köşeler
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ],
);

final BoxDecoration kProductCardBoxDecoration = BoxDecoration(
  color: Colors.white, // Kutunun arka plan rengi
  borderRadius: BorderRadius.circular(15), // Yuvarlatılmış köşeler
  boxShadow: [
    BoxShadow(
      color: Colors.black,
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ],
);

const SliverGridDelegateWithFixedCrossAxisCount
    kSliverGridDelegateWithFixedCrossAxisCount =
    SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2, // İki sütunlu bir grid
  crossAxisSpacing: 20.0,
  mainAxisSpacing: 20.0,
  childAspectRatio: 1, // Kare kutucuklar
);

final InputDecoration kSearchTextFieldInputDecoration = InputDecoration(
  hintText: 'Marka, ürün veya kategori ara',
  border: InputBorder.none,
  hintStyle: TextStyle(color: Colors.grey[600]),
);

final BoxDecoration kSearchTextFieldBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 5,
      offset: const Offset(0, 3),
    ),
  ],
);
