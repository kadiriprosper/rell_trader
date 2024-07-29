import 'package:flutter/material.dart';

class TradeDetailsRowWidget extends StatelessWidget {
  const TradeDetailsRowWidget({
    super.key,
    required this.label,
    required this.labelColor,
    required this.body,
    required this.bodyColor,
    required this.labelFontWeight,
    required this.bodyFontWeight,
    this.fontSize,
  });

  final String label;
  final Color labelColor;
  final String body;
  final Color bodyColor;
  final FontWeight labelFontWeight;
  final FontWeight bodyFontWeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: labelFontWeight,
            fontSize: fontSize ?? 18,
            color: labelColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(
            thickness: .2,
            color: bodyColor,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          body,
          style: TextStyle(
            fontWeight: bodyFontWeight,
            fontSize: fontSize ?? 18,
            color: bodyColor,
          ),
        ),
      ],
    );
  }
}
