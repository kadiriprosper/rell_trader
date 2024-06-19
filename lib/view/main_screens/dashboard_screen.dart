import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/trade_controller.dart';
import 'package:rell_trader/model/active_trade_model.dart';
import 'package:rell_trader/model/trade_model.dart';
import 'package:rell_trader/view/main_screens/widgets/active_trade_widget.dart';
import 'package:rell_trader/view/profile_page.dart';
import 'package:rell_trader/view/trade_details_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool hasData = false;
  // PremiumTradeModel? currentTrade;
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
        actions: [
          // RawChip(
          //   label: Text(
          //     'Pro Mode',
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   elevation: 2,
          //   shadowColor: Colors.green,
          //   avatar: Icon(
          //     Icons.paid,
          //     color: Colors.orange,
          //   ),
          //   onPressed: null, //TODO: Separate free from paid later
          //   // () {
          //   //   // Get.to(() => const PremiumScreen());
          //   // },
          // ),
          InkWell(
            onTap: () {
              Get.to(
                () => const ProfilePage(),
              );
            },
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.green,
              child: CircleAvatar(
                radius: 21,
                backgroundColor: Colors.white70,
                child: Icon(Icons.person_outline),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 20),
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
                        final List<TradeSignalModel> tempTradeModel = [
                          ActiveTradeModel.fromMap(
                            jsonDecode(snapshot.data)['data'],
                          ),
                          ...tradeController.tradingSignalModels
                        ];
                        // .insert(
                        //   0,
                        //   ActiveTradeModel.fromMap(
                        //     jsonDecode(snapshot.data)['data'],
                        //   ),
                        // );
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
                                return InkWell(
                                  onTap: () {
                                    print('Hello WOrls;');
                                    tradeController.currentSelectedSignal =
                                        tempTradeModel[index].obs;
                                    // tradeController
                                    //     .tradingSignalModels[index];
                                    Get.to(() => const TradeDetailsPage());
                                  },
                                  child: tempSignals[index],
                                );
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
                        //TODO: Test this guy
                        tradeController.initTradingSignals();
                        // currentTrade = PremiumTradeModel.fromMap(
                        //   jsonDecode(snapshot.data),
                        // );

                        // // If the trade has been completed, add it to the already exitsting trading signals
                        // tradeController.tradingSignals.add(
                        //   PremiumSignalCardWidget(
                        //     dateCreated:
                        //         '${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}:${DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.now())}',
                        //     tradingPair: tradingPair.first,
                        //     result: currentTrade!.response,
                        //     currentPhase: currentTrade!.currentPhase.toString(),
                        //     currentStep: currentTrade!.currentPhase.toString(),
                        //     lotSize: currentTrade!.lotSize.toStringAsFixed(2),
                        //     takeProfit:
                        //         currentTrade!.takeProfit.toStringAsFixed(2),
                        //     stopLoss: currentTrade!.stopLoss.toStringAsFixed(2),
                        //     tradeType: currentTrade!.tradeType,
                        //     newAccountBalance: currentTrade!.newAccountBalance
                        //         .toStringAsFixed(2),
                        //   ),
                        // );
                      }
                    } catch (e) {
                      print('error: $e');
                    }
                  }
                  // If trading signal is not empty, then present it to the user
                  if (tradeController.tradingSignals.isNotEmpty) {
                    return Obx(
                      () => ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: tradeController.tradingSignals.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(
                          height: .1,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                print('Hello WOrls;');
                                tradeController.currentSelectedSignal =
                                    tradeController.tradingSignalModels[index].obs;
                                Get.to(() => const TradeDetailsPage());
                              },
                              child: tradeController.tradingSignals[index]);
                        },
                      ),
                    );
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
