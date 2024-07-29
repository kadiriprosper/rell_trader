import 'package:flutter/material.dart';

class ProfileSegmentWidget extends StatelessWidget {
  const ProfileSegmentWidget({
    super.key,
    required this.segmentLabel,
    required this.children,
  });

  final String segmentLabel;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            segmentLabel,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...children
        ],
      ),
    );
  }
}
