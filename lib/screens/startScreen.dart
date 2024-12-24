import 'package:final_projesi/constants.dart';
import 'package:final_projesi/customWidgets/customElevatedButton.dart';
import 'package:final_projesi/screens/singInScreen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              'WELCOME',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            CustomElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SingInScreen()),
                );
              },
              buttonTittle: "START",
            )
          ],
        ),
      ),
    );
  }
}

