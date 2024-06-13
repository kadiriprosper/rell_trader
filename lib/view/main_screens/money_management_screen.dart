// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:rell_trader/controller/main_screen_navigation_controller.dart';
// import 'package:rell_trader/controller/trade_controller.dart';
// import 'package:rell_trader/model/active_trade_model.dart';
// import 'package:rell_trader/model/premium_trade_model.dart';
// import 'package:rell_trader/view/main_screens/profile_screen.dart';
// import 'package:rell_trader/view/main_screens/widgets/active_trade_widget.dart';
// import 'package:rell_trader/view/main_screens/widgets/base_main_screen.dart';
// import 'package:rell_trader/view/main_screens/widgets/symbol_row_widget.dart';

// import 'widgets/custom_main_screen_button.dart';
// import 'widgets/signal_card_widget.dart';

// class MoneyManagementScreen extends StatefulWidget {
//   const MoneyManagementScreen({super.key});

//   @override
//   State<MoneyManagementScreen> createState() => _MoneyManagementScreenState();
// }

// class _MoneyManagementScreenState extends State<MoneyManagementScreen> {
//   bool hasData = false;
//   PremiumTradeModel? currentTrade;
//   ActiveTradeModel? activeTrade;
//   TradeController tradeController = Get.put(TradeController());
//   MainScreenNavigationController mainScreenNavigationController =
//       Get.put(MainScreenNavigationController());

//   // final channel = WebSocketChannel.connect(
//   //   Uri.parse('ws://81.0.249.14:80/ws/check/free'),
//   // );

//   @override
//   Widget build(BuildContext context) {
//     return BaseMainScreen(
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: const Text('Money Management'),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               //TODO-TEST: Test the stream builder here
//               StreamBuilder(
//                 stream: tradeController.streamController.stream,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     if (jsonDecode(snapshot.data)['status'] == false &&
//                         !hasData &&
//                         tradeController.tradingSignals.isEmpty) {
//                       print({'Current Status': 'False'});
//                     } else {
//                       print(snapshot.data);

//                       if (jsonDecode(snapshot.data)['status'] == true) {
//                         try {
//                           if (jsonDecode(snapshot.data)['message'] ==
//                               'active trade in progress') {
//                             print('started');
//                             activeTrade = ActiveTradeModel.fromMap(
//                               jsonDecode(snapshot.data)['data'],
//                             );
//                             print('model created');
//                             return ActiveTradeWidget(activeTrade: activeTrade);
//                           } else if (jsonDecode(snapshot.data)['message'] ==
//                               'Trade completed') {
//                             currentTrade = PremiumTradeModel.fromMap(
//                               jsonDecode(snapshot.data),
//                             );
//                             if (tradeController.tradingSignals.length > 2) {
//                               tradeController.tradingSignals.removeAt(0);
//                             }
//                             return PremiumSignalCardWidget(
//                               dateCreated:
//                                   '${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}:${DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.now())}',
//                               tradingPair: tradingPair.first,
//                               result: currentTrade!.response,
//                               currentPhase:
//                                   currentTrade!.currentPhase.toString(),
//                               currentStep:
//                                   currentTrade!.currentPhase.toString(),
//                               lotSize: currentTrade!.lotSize.toStringAsFixed(2),
//                               takeProfit:
//                                   currentTrade!.takeProfit.toStringAsFixed(2),
//                               stopLoss:
//                                   currentTrade!.stopLoss.toStringAsFixed(2),
//                               newAccountBalance: currentTrade!.newAccountBalance
//                                   .toStringAsFixed(2),
//                             );
//                           }
//                         } catch (_) {
//                           print('error');
//                         }

//                         // try {
//                         //   currentTrade = PremiumTradeModel.fromMap(
//                         //     jsonDecode(snapshot.data),
//                         //   );
//                         //   if (tradeController.tradingSignals.length > 2) {
//                         //     tradeController.tradingSignals.removeAt(0);
//                         //   }
//                         //   tradeController.tradingSignals.insert(
//                         //     0,
//                         //     PremiumSignalCardWidget(
//                         //       dateCreated:
//                         //           '${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}:${DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.now())}',
//                         //       tradingPair: tradingPair.first,
//                         //       result: currentTrade!.response,
//                         //       currentPhase:
//                         //           currentTrade!.currentPhase.toString(),
//                         //       currentStep:
//                         //           currentTrade!.currentPhase.toString(),
//                         //       lotSize: currentTrade!.lotSize.toStringAsFixed(2),
//                         //       takeProfit:
//                         //           currentTrade!.takeProfit.toStringAsFixed(2),
//                         //       stopLoss:
//                         //           currentTrade!.stopLoss.toStringAsFixed(2),
//                         //       newAccountBalance: currentTrade!.newAccountBalance
//                         //           .toStringAsFixed(2),
//                         //     ),

//                         //     // SignalCardWidget(
//                         //     //   dateCreated:
//                         //     //       '${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}:${DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.now())}',
//                         //     //   tradingPair: tradingPair.first,
//                         //     //   condition: currentTrade!.condition,
//                         //     //   rsi: currentTrade!.rsi.toStringAsFixed(2),
//                         //     //   sma: currentTrade!.sl.toStringAsFixed(2),
//                         //     //   tp: currentTrade!.tp.toStringAsFixed(2),
//                         //     //   currentPrice:
//                         //     //       currentTrade!.currentPrice.toStringAsFixed(2),
//                         //     // ),
//                         //   );
//                         //   hasData = true;
//                         // } catch (_) {
//                         //   //Do nothing
//                         // }
//                       }
//                       if (tradeController.tradingSignals.isNotEmpty) {
//                         return Obx(() => ListView.separated(
//                               itemCount: tradeController.tradingSignals.length,
//                               shrinkWrap: true,
//                               separatorBuilder: (context, index) =>
//                                   const SizedBox(
//                                 height: 6,
//                               ),
//                               itemBuilder: (context, index) {
//                                 return tradeController.tradingSignals[index];
//                               },
//                             ));
//                       } else {
//                         return const Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             CircularProgressIndicator(
//                               color: Colors.green,
//                             ),
//                             SizedBox(
//                               width: double.infinity,
//                               height: 10,
//                             ),
//                             Text(
//                               'Checking Market Conditions',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.lightGreen,
//                               ),
//                             ),
//                           ],
//                         );
//                       }
//                     }
//                     //   return SignalCardWidget(
//                     //     lotSize: '0.01',
//                     //     tradingPair: 'XAUUSD',
//                     //     openPrice: '1.0234',
//                     //     stopLoss: '1.08204',
//                     //     takeProfit: '1.082084',
//                     //     expiration: '10mins',
//                     //   );
//                   }
//                   return const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         color: Colors.green,
//                       ),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 10,
//                       ),
//                       Text(
//                         'Checking Market Conditions',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.lightGreen,
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               // Container(
//               //   padding: const EdgeInsets.all(20).copyWith(bottom: 10, left: 14),
//               //   margin: const EdgeInsets.symmetric(horizontal: 12),
//               //   width: double.infinity,
//               //   decoration: BoxDecoration(
//               //     borderRadius: BorderRadius.circular(12),
//               //     color: const Color.fromARGB(255, 5, 117, 208),
//               //   ),
//               //   child: Column(
//               //     crossAxisAlignment: CrossAxisAlignment.start,
//               //     children: [
//               //       const Text(
//               //         'Upgrade to RellTrader Pro,',
//               //         style: TextStyle(
//               //           fontSize: 12,
//               //           color: Colors.white,
//               //         ),
//               //       ),
//               //       const SizedBox(height: 6),
//               //       const Text(
//               //         // 'Unlock advanced features and\nmaximize your trading potential\nwith RellTrader Premium',
//               //         'Get 100% monthly profit guaranteed,\n30 days money back also guaranteed.\nTry for free today.',
//               //         style: TextStyle(
//               //           fontSize: 14,
//               //           color: Colors.white,
//               //         ),
//               //       ),
//               //       const SizedBox(height: 16),
//               //       CustomMainScreenButton(
//               //         buttonColor: Colors.white,
//               //         buttonTextColor: const Color.fromARGB(255, 5, 117, 208),
//               //         label: 'Upgrade now',
//               //         onPressed: () {
//               //           // Get.to(() => const PaymentPage());
//               //         },
//               //       ),
//               //     ],
//               //   ),
//               // ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

