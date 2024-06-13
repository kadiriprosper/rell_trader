// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:rell_trader/controller/main_screen_navigation_controller.dart';
// import 'package:rell_trader/controller/trade_controller.dart';
// import 'package:rell_trader/view/main_screens/dashboard_screen.dart';
// import 'package:rell_trader/view/main_screens/money_management_screen.dart';
// import 'package:rell_trader/view/main_screens/profile_screen.dart';
// import 'package:rell_trader/view/main_screens/trade_history_screen.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   MainScreenNavigationController mainScreenNavigationController =
//       Get.put(MainScreenNavigationController());
//   TradeController tradeController = Get.put(TradeController())..openConnection();
//   final screens = const [
//     DashboardScreen(),
//     TradeHistoryScreen(),
//     MoneyManagementScreen(),
//     ProfileScreen(),
//   ];

//   @override
//   void initState() {
    
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: const Color.fromARGB(255, 238, 238, 238),
//       body: SafeArea(
//         child: Obx(() => screens[mainScreenNavigationController.currentIndex]),
//       ),
//       bottomNavigationBar: Obx(
//         () => BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           currentIndex: mainScreenNavigationController.currentIndex,
//           onTap: (value) {
//             setState(() {
//               mainScreenNavigationController.currentIndex = value;
//             });
//           },
//           selectedItemColor: const Color.fromARGB(255, 30, 97, 32),
//           unselectedItemColor: Colors.grey,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home_outlined),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.area_chart_outlined),
//               label: 'Trade history',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.card_giftcard_outlined),
//               label: 'Money Management',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person_outline),
//               label: 'Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
