import 'package:final_projesi/constants.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton({super.key,required this.onPressed,required this.buttonTittle});
  final VoidCallback? onPressed;
  final String buttonTittle;

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          backgroundColor: kElevatedButtonBackgroundColor,
          foregroundColor: kElevatedButtonForegroundColor),
      onPressed: widget.onPressed,
      child:  Text('${widget.buttonTittle.toUpperCase()}'),
    );
  }
}
