import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/trade_controller.dart';
import 'package:rell_trader/firebase_options.dart';
import 'package:rell_trader/view/profile_page.dart';
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
    return const GetMaterialApp(
      // debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
