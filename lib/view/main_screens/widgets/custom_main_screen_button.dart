import 'package:flutter/material.dart';

class CustomMainScreenButton extends StatelessWidget {
  const CustomMainScreenButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.buttonColor,
    required this.buttonTextColor,
  });

  final VoidCallback onPressed;
  final String label;
  final Color buttonColor;
  final Color buttonTextColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: buttonColor,
      height: 40,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: buttonTextColor,
        ),
      ),
    );
  }
}
