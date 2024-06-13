import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/push_notification_controller.dart';
import 'package:rell_trader/controller/trade_controller.dart';
import 'package:rell_trader/firebase_options.dart';
import 'package:rell_trader/view/main_screens/dashboard_screen.dart';
import 'package:rell_trader/view/main_screens/main_screen.dart';
import 'package:rell_trader/view/main_screens/premium_screen.dart';
import 'package:rell_trader/view/splash_screen.dart';

TradeController tradeController = Get.put(TradeController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // PushNotificationController pushNotificationController =
  //     Get.put(PushNotificationController());
  // await pushNotificationController.initNotifications();

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
