import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rell_trader/controller/user_controller.dart';
import 'package:rell_trader/view/auth/login_screen.dart';
import 'package:rell_trader/view/main_screens/dashboard_screen.dart';
import 'package:rell_trader/view/main_screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: () async {
            const secureStorage = FlutterSecureStorage();
            if (await secureStorage.read(key: 'email') == null) {
              Get.to(() => const LoginScreen());
            } else {
              final controller = Get.put(UserController());

              final response = await controller.userLogin(
                email: (await secureStorage.read(key: 'email'))!,
                password: (await secureStorage.read(key: 'password'))!,
              );
              if (response) {
                Get.to(() => const DashboardScreen());
              }
            }
          }.call(),
          builder: (context, snapshot) {
            return Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: double.infinity),
                    Text(
                      'RellTrader.',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'For Real Traders',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Positioned(
                  bottom: 30,
                  right: 0,
                  left: 0,
                  child: SpinKitRipple(
                    color: Colors.purple,
                    size: 42,
                  ),
                )
              ],
            );
          }),
    );
  }
}
