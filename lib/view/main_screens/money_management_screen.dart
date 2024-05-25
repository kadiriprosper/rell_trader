import 'package:flutter/material.dart';
import 'package:rell_trader/view/main_screens/widgets/base_main_screen.dart';

class MoneyManagementScreen extends StatelessWidget {
  const MoneyManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseMainScreen(
      child: Center(child: Center(child: Text('Money management screen'))),
    );
  }
}
