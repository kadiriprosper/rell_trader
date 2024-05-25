import 'package:flutter/material.dart';

class CustomAuthTextField extends StatelessWidget {
  const CustomAuthTextField({
    super.key,
    required this.textController,
    required this.hintText,
    required this.label,
    required this.prefixIcon,
    required this.validater,
    required this.textInputType,
    this.onSuffixIconClick,
    this.obscureText,
  });

  final TextEditingController textController;
  final String hintText;
  final String label;
  final Icon prefixIcon;
  final String? Function(String?) validater;
  final TextInputType textInputType;
  final bool? obscureText;
  final VoidCallback? onSuffixIconClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: obscureText != null ? obscureText! : false,
          controller: textController,
          keyboardType: textInputType,
          validator: (value) {
            return validater(value);
          },
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: prefixIcon,
            ),
            suffixIcon: obscureText != null
                ? obscureText!
                    ? IconButton(
                        icon: const Icon(Icons.remove_red_eye_outlined),
                        onPressed: onSuffixIconClick,
                      )
                    : IconButton(
                        icon: const Icon(Icons.energy_savings_leaf_outlined),
                        onPressed: onSuffixIconClick,
                      )
                : null,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
