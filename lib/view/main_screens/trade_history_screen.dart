import 'package:flutter/material.dart';
import 'package:rell_trader/view/main_screens/widgets/base_main_screen.dart';

class TradeHistoryScreen extends StatelessWidget {
  const TradeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseMainScreen(
      child: Center(child: Text('Trade History screen')),
    );
  }
}
