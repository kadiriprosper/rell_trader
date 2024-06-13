import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rell_trader/controller/main_screen_navigation_controller.dart';
import 'package:rell_trader/controller/trade_controller.dart';
import 'package:rell_trader/main.dart';
import 'package:rell_trader/model/active_trade_model.dart';
import 'package:rell_trader/model/premium_trade_model.dart';
import 'package:rell_trader/model/trade_model.dart';
import 'package:rell_trader/view/main_screens/premium_screen.dart';
import 'package:rell_trader/view/main_screens/profile_screen.dart';
import 'package:rell_trader/view/main_screens/widgets/active_trade_widget.dart';
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
  PremiumTradeModel? currentTrade;
  ActiveTradeModel? activeTrade;
  TradeController tradeController = Get.put(TradeController())
    ..openConnection();

  // final channel = WebSocketChannel.connect(
  //   Uri.parse('ws://81.0.249.14:80/ws/check/free'),
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //TODO: Make a little animation here from RellTrader to Live Signals
        title: const Text('Live Signals'),
        actions: const [
          RawChip(
            label: Text(
              'Pro Mode',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 2,
            shadowColor: Colors.green,
            avatar: Icon(
              Icons.paid,
              color: Colors.orange,
            ),
            onPressed: null, //TODO: Separate free from paid later
            // () {
            //   // Get.to(() => const PremiumScreen());
            // },
          ),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 20),
            // Container(
            //   padding:
            //       const EdgeInsets.all(20).copyWith(bottom: 10, left: 14),
            //   margin: const EdgeInsets.symmetric(horizontal: 12),
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(12),
            //     color: const Color.fromARGB(255, 24, 111, 27),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         'Welcome Again,',
            //         style: TextStyle(
            //           fontSize: 18,
            //           color: Colors.white,
            //         ),
            //       ),
            //       const SizedBox(height: 2),
            //       const SizedBox(height: 16),
            //       CustomMainScreenButton(
            //         buttonColor: Colors.white,
            //         buttonTextColor: const Color.fromARGB(255, 24, 111, 27),
            //         label: 'Get funding for trading',
            //         onPressed: () {},
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 16),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         'Signals',
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       MaterialButton(
            //         onPressed: () {
            //           mainScreenNavigationController.currentIndex = 1;
            //         },
            //         textColor: Colors.green,
            //         child: const Text('View all'),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 20),
            StreamBuilder(
              stream: tradeController.streamController.stream,
              builder: (context, snapshot) {
                //Check to see if data is being returned from the channel
                if (snapshot.hasData) {
                  // Check to see if the data status is false and
                  // there has been no data passed from the channel
                  // and there is no signal in the trade history
                  if (jsonDecode(snapshot.data)['status'] == false &&
                      !hasData &&
                      tradeController.tradingSignals.isEmpty) {
                    print({'Current Status': 'False'});
                  } else {
                    print(snapshot.data);
                    try {
                      // Tries to checek the current status returns an active trade
                      if (jsonDecode(snapshot.data)['message'] ==
                          'active trade in progress') {
                        print('started');
                        print(jsonDecode(snapshot.data)['data']);
                        // If there is an active trade, parse it into the active trade model
                        activeTrade = ActiveTradeModel.fromMap(
                          jsonDecode(snapshot.data)['data'],
                        );
                        print('model created');

                        // Check to see if the signal list is empty
                        if (tradeController.tradingSignals.isNotEmpty) {
                          // Create a temporary list and then add the active trade to the top of the list
                          final tempSignals = [
                            ActiveTradeWidget(activeTrade: activeTrade),
                            ...tradeController.tradingSignals,
                          ];
                          return Obx(
                            () => ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: tempSignals.length,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                height: .1,
                              ),
                              //     const SizedBox(
                              //   height: 6,
                              // ),
                              itemBuilder: (context, index) {
                                return tempSignals[index];
                              },
                            ),
                          );
                        } else {
                          // If there are no past trades, return the current active trade
                          return ActiveTradeWidget(activeTrade: activeTrade);
                        }
                      }

                      // Checks to see if the current trade is completed
                      else if (jsonDecode(snapshot.data)['message'] ==
                          'Trade completed') {
                        currentTrade = PremiumTradeModel.fromMap(
                          jsonDecode(snapshot.data),
                        );

                        // If the trade has been completed, add it to the already exitsting trading signals
                        tradeController.tradingSignals.add(
                          PremiumSignalCardWidget(
                            dateCreated:
                                '${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}:${DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.now())}',
                            tradingPair: tradingPair.first,
                            result: currentTrade!.response,
                            currentPhase: currentTrade!.currentPhase.toString(),
                            currentStep: currentTrade!.currentPhase.toString(),
                            lotSize: currentTrade!.lotSize.toStringAsFixed(2),
                            takeProfit:
                                currentTrade!.takeProfit.toStringAsFixed(2),
                            stopLoss: currentTrade!.stopLoss.toStringAsFixed(2),
                            tradeType: currentTrade!.tradeType,
                            newAccountBalance: currentTrade!.newAccountBalance
                                .toStringAsFixed(2),
                          ),
                        );
                      }
                    } catch (e) {
                      print('error: $e');
                    }
                  }
                  // If trading signal is not empty, then present it to the user
                  if (tradeController.tradingSignals.isNotEmpty) {
                    return Obx(() => ListView.separated(
                          itemCount: tradeController.tradingSignals.length,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => const Divider(
                            height: .1,
                          ),
                          itemBuilder: (context, index) {
                            return tradeController.tradingSignals[index];
                          },
                        ));
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
                          'Checking Market Conditions',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ],
                    );
                  }
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
