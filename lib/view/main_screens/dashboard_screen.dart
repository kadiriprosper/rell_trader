import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rell_trader/controller/main_screen_navigation_controller.dart';
import 'package:rell_trader/controller/trade_controller.dart';
import 'package:rell_trader/model/trade_model.dart';
import 'package:rell_trader/view/main_screens/profile_screen.dart';
import 'package:rell_trader/view/main_screens/widgets/base_main_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'widgets/custom_main_screen_button.dart';
import 'widgets/signal_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool hasData = false;
  TradeModel? currentTrade;
  TradeController tradeController = Get.put(TradeController());
  MainScreenNavigationController mainScreenNavigationController =
      Get.put(MainScreenNavigationController());

  final channel = WebSocketChannel.connect(
    Uri.parse('ws://81.0.249.14:80/ws/check/free'),
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
    return BaseMainScreen(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.paid),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.all(20).copyWith(bottom: 10, left: 14),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 24, 111, 27),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Welcome Again,',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // const Text(
                    //   'Fund account for trading',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    CustomMainScreenButton(
                      buttonColor: Colors.white,
                      buttonTextColor: const Color.fromARGB(255, 24, 111, 27),
                      label: 'Get funding for trading',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Signals',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        mainScreenNavigationController.currentIndex = 1;
                      },
                      textColor: Colors.green,
                      child: const Text('View all'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //TODO-TEST: Test the stream builder here
              StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (jsonDecode(snapshot.data)['status'] == false &&
                        !hasData && tradeController.tradingSignals.isEmpty) {
                      print({'Current Status': 'False'});
                    } else {
                      print(snapshot.data);

                      if (jsonDecode(snapshot.data)['status'] == true) {
                        currentTrade = TradeModel.fromMap(
                          jsonDecode(snapshot.data),
                        );
                        if (tradeController.tradingSignals.length > 2) {
                          tradeController.tradingSignals.removeAt(0);
                        }
                        tradeController.tradingSignals.add(
                          SignalCardWidget(
                            dateCreated:
                                '${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}:${DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.now())}',
                            tradingPair: tradingPair.first,
                            condition: currentTrade!.condition,
                            rsi: currentTrade!.rsi.toStringAsFixed(2),
                            sma: currentTrade!.sl.toStringAsFixed(2),
                            tp: currentTrade!.tp.toStringAsFixed(2),
                            currentPrice:
                                currentTrade!.currentPrice.toStringAsFixed(2),
                          ),
                        );
                      }
                      hasData = true;
                      return ListView.separated(
                        reverse: true,
                        itemCount: tradeController.tradingSignals.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 6,
                        ),
                        itemBuilder: (context, index) {
                          return tradeController.tradingSignals[index];
                        },
                      );
                    }
                    //   return SignalCardWidget(
                    //     lotSize: '0.01',
                    //     tradingPair: 'XAUUSD',
                    //     openPrice: '1.0234',
                    //     stopLoss: '1.08204',
                    //     takeProfit: '1.082084',
                    //     expiration: '10mins',
                    //   );
                  }

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
                        'Checking Market Conditions',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              // Container(
              //   padding: const EdgeInsets.all(20).copyWith(bottom: 10, left: 14),
              //   margin: const EdgeInsets.symmetric(horizontal: 12),
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(12),
              //     color: const Color.fromARGB(255, 5, 117, 208),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text(
              //         'Upgrade to RellTrader Pro,',
              //         style: TextStyle(
              //           fontSize: 12,
              //           color: Colors.white,
              //         ),
              //       ),
              //       const SizedBox(height: 6),
              //       const Text(
              //         // 'Unlock advanced features and\nmaximize your trading potential\nwith RellTrader Premium',
              //         'Get 100% monthly profit guaranteed,\n30 days money back also guaranteed.\nTry for free today.',
              //         style: TextStyle(
              //           fontSize: 14,
              //           color: Colors.white,
              //         ),
              //       ),
              //       const SizedBox(height: 16),
              //       CustomMainScreenButton(
              //         buttonColor: Colors.white,
              //         buttonTextColor: const Color.fromARGB(255, 5, 117, 208),
              //         label: 'Upgrade now',
              //         onPressed: () {
              //           // Get.to(() => const PaymentPage());
              //         },
              //       ),
              //     ],
              //   ),
              // ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
