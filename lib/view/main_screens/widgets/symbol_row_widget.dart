import 'package:flutter/material.dart';

/// This is the row of the Symbol Widget.
/// [label] is the label of the row.
/// [size] is the lot size.
/// [isHigher] affects the color. If the size is higher than the chart size,
/// the color would be green, otherwise red
class SymbolRowWidget extends StatelessWidget {
  const SymbolRowWidget({
    super.key,
    required this.label,
    required this.size,
    this.isHigher,
  });

  final String label;
  final String size;
  final bool? isHigher;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          size,
          style: TextStyle(
            color: isHigher == null
                ? Colors.black
                : isHigher == true
                    ? Colors.green
                    : Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
