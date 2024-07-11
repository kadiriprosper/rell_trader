import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/trade_controller.dart';
import 'package:rell_trader/model/active_trade_model.dart';
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
  List<ActiveTradeModel> tempActiveTradeList = [];
  late ActiveTradeModel activeTrade;
  TradeController tradeController = Get.put(TradeController())
    ..openConnection();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Live Signals'),
        actions: [
          InkWell(
            onTap: () async {
              Get.to(
                () => const ProfilePage(),
              );
            },
            borderRadius: BorderRadius.circular(30),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white70,
                child: Icon(Icons.person_outline),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 20),
            StreamBuilder(
              stream: tradeController.streamController,
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
                      bool tradeExists = false;
                      if (jsonDecode(snapshot.data)['message'] ==
                          'active trade in progress') {
                        // print(jsonDecode(snapshot.data)['data']);

                        // If there is an active trade, parse it into the active trade model
                        activeTrade = ActiveTradeModel.fromMap(
                          jsonDecode(snapshot.data)['data'],
                        );

                        //TODO: We would still have to check for whether the trade is finished
                        for (int i = 0; i < tempActiveTradeList.length; i++) {
                          if (tempActiveTradeList[i].compareTo(activeTrade)) {
                            tempActiveTradeList[i] = activeTrade;
                            tradeExists = true;
                          }
                        }
                        if (!tradeExists) {
                          tempActiveTradeList.add(activeTrade);
                        }
                        tradeController.tempTradeModel = [
                          ...tempActiveTradeList,
                          ...tradeController.tradingSignalModels
                        ].obs;

                        tradeExists = false;

                        // Check to see if the signal list is empty
                        if (tradeController.tradingSignals.isNotEmpty) {
                          // Create a temporary list and then add the active trade to the top of the list
                          final tempSignals = [
                            ...List.generate(
                              tempActiveTradeList.length,
                              (index) => ActiveTradeWidget(
                                activeTrade: tempActiveTradeList[index],
                              ),
                            ),
                            // ActiveTradeWidget(activeTrade: activeTrade),
                            ...tradeController.tradingSignals,
                          ];

                          return Obx(
                            () => ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
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
                                    tradeController
                                        .currentSelectedTradeModelIndex = index;
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
                        tradeController.initTradingSignals();
                      }
                    } catch (e) {
                      print('error: $e');
                    }
                  }
                  // If trading signal is not empty, then present it to the user
                  if (tradeController.tradingSignals.isNotEmpty) {
                    tradeController.tempTradeModel =
                        tradeController.tradingSignalModels;
                    return Obx(
                      () => ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tradeController.tradingSignals.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(
                          height: .1,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                tradeController.currentSelectedSignal =
                                    tradeController
                                        .tradingSignalModels[index].obs;
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
                } else if (tradeController.tradingSignals.isNotEmpty) {
                  tradeController.tempTradeModel =
                      tradeController.tradingSignalModels;
                  return Obx(
                    () => ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tradeController.tradingSignals.length,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const Divider(
                        height: .1,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              tradeController.currentSelectedTradeModelIndex =
                                  index;
                              // tradeController.currentSelectedSignal =
                              //     tradeController
                              //         .tradingSignalModels[index].obs;
                              Get.to(() => const TradeDetailsPage());
                            },
                            child: tradeController.tradingSignals[index]);
                      },
                    ),
                  );
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
