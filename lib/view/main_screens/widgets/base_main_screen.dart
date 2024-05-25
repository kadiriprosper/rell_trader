import 'package:flutter/material.dart';

class BaseMainScreen extends StatelessWidget {
  const BaseMainScreen({
    super.key,
    required this.child,
  });

  final Widget child;  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: child,
    );
  }
}
