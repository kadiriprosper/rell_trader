import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://81.0.249.14:80/ws/check/premium'),
  );

  @override
  void initState() {
    channel.sink.add(jsonEncode({"msg": "ping"}));
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pro Signal'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8).copyWith(top: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Pro Signals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (jsonDecode(snapshot.data)['status'] == false) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Current Trade Status'),
                                Text(
                                  'False',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text('Status Message:'),
                            Text(
                              jsonDecode(snapshot.data)['message'],
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Current Trade Status'),
                                Text(
                                  'True',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text('Status Message:'),
                            Text(
                              jsonDecode(snapshot.data)['message'],
                              style: TextStyle(
                                color: jsonDecode(snapshot.data)['message'] ==
                                        'loss'
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  } else {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 10,
                        ),
                        Text(
                          'Getting Trade Status',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}






// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:rell_trader/controller/trade_controller.dart';
// import 'package:rell_trader/model/trade_model.dart';
// import 'package:rell_trader/view/main_screens/dashboard_screen.dart';
// import 'package:rell_trader/view/main_screens/profile_screen.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class PremiumScreen extends StatefulWidget {
//   const PremiumScreen({super.key});

//   @override
//   State<PremiumScreen> createState() => _PremiumScreenState();
// }

// class _PremiumScreenState extends State<PremiumScreen> {
//   TradeController tradeController = Get.put(TradeController());
//   bool hasData = false;
//   TradeModel? currentTrade;
//   final channel = WebSocketChannel.connect(
//     Uri.parse('ws://81.0.249.14:80/ws/check/premium'),
//   );

//   @override
//   void initState() {
//     channel.sink.add(jsonEncode({"msg": "ping"}));
//     super.initState();
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: const BackButton(),
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         child: Stack(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Premium Signals',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 Row(
//                   children: [
//                     const Text(
//                       'Current Max. Risk: ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const Spacer(),
//                     Obx(
//                       () => Text(
//                         '${tradeController.selectedMaximumRisk.toStringAsFixed(1)}%',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 StreamBuilder(
//                   stream: channel.stream,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       if (jsonDecode(snapshot.data)['status'] == false &&
//                           !hasData) {
//                         print({'Current Status': 'False from premium screen'});
//                       } else {
//                         print(snapshot.data);

//                         if (jsonDecode(snapshot.data)['status'] == true) {
//                           currentTrade = TradeModel.fromMap(
//                             jsonDecode(snapshot.data),
//                           );
//                         }
//                         hasData = true;
//                         return SignalCardWidget(
//                           tradingPair: tradingPair.first,
//                           condition: currentTrade!.condition,
//                           rsi: currentTrade!.rsi.toStringAsFixed(2),
//                           sma: currentTrade!.sl.toStringAsFixed(2),
//                           tp: currentTrade!.tp.toStringAsFixed(2),
//                           currentPrice:
//                               currentTrade!.currentPrice.toStringAsFixed(2),
//                         );
//                       }
//                       //   return SignalCardWidget(
//                       //     lotSize: '0.01',
//                       //     tradingPair: 'XAUUSD',
//                       //     openPrice: '1.0234',
//                       //     stopLoss: '1.08204',
//                       //     takeProfit: '1.082084',
//                       //     expiration: '10mins',
//                       //   );
//                     }

//                     return const Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(
//                           color: Colors.green,
//                         ),
//                         SizedBox(
//                           width: double.infinity,
//                           height: 10,
//                         ),
//                         Text(
//                           'Checking Market Conditions',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.lightGreen,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 // InkWell(
//                 //   onTap: () {
//                 //     Get.dialog(
//                 //       const Dialog(
//                 //         child: TakeTradeDialogBox(),
//                 //       ),
//                 //     );
//                 //   },
//                 //   borderRadius: BorderRadius.circular(20),
//                 //   child: const SignalCardWidget(
//                 //     lotSize: '0.01',
//                 //     tradingPair: 'XAUUSD',
//                 //     openPrice: '1.0234',
//                 //     stopLoss: '1.08204',
//                 //     takeProfit: '1.082084',
//                 //     expiration: '10mins',
//                 //   ),
//                 // ),
//                 // const SizedBox(height: 12),
//                 // InkWell(
//                 //   onTap: () {
//                 //     Get.dialog(
//                 //       const Dialog(
//                 //         child: TakeTradeDialogBox(),
//                 //       ),
//                 //     );
//                 //   },
//                 //   borderRadius: BorderRadius.circular(20),
//                 //   child: const SignalCardWidget(
//                 //     lotSize: '0.01',
//                 //     tradingPair: 'XAUUSD',
//                 //     openPrice: '1.0234',
//                 //     stopLoss: '1.08204',
//                 //     takeProfit: '1.082084',
//                 //     expiration: '10mins',
//                 //   ),
//                 // ),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TakeTradeDialogBox extends StatelessWidget {
//   const TakeTradeDialogBox({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//       height: 120,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const Spacer(),
//           const Text(
//             'Take trade?',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const Spacer(),
//           ButtonBar(
//             alignment: MainAxisAlignment.end,
//             children: [
//               MaterialButton(
//                 onPressed: () {
//                   Get.back();
//                 },
//                 child: const Text('No'),
//               ),
//               MaterialButton(
//                 onPressed: () {
//                   //TODO: Place the trade
//                 },
//                 color: Colors.green,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Text('Yes'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
