// uygulamanın kök widgetı
import 'package:flutter/material.dart';
import 'constants.dart';
import 'models/product.dart';
import 'screens/screens.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Final Projesi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: kScaffoldBackgroundColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/home': (context) => const HomeScreen(),
        '/signIn': (context) => const SingInScreen(),
        '/signUp': (context) => const SingUpScreen(),
        '/userProfile': (context) => const UserProfileScreen(),
        '/userDetail': (context) => UserDetailScreen(
            product: ModalRoute.of(context)!.settings.arguments as Product),
        '/updateProduct': (context) => UpdateProductScreen(
            product: ModalRoute.of(context)!.settings.arguments as Product),
      },
    );
  }
}