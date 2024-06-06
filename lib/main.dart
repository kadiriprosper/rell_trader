import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/trade_controller.dart';
import 'package:rell_trader/view/main_screens/dashboard_screen.dart';
import 'package:rell_trader/view/main_screens/main_screen.dart';
import 'package:rell_trader/view/main_screens/premium_screen.dart';
import 'package:rell_trader/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}
