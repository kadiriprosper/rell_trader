import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rell_trader/controller/trade_controller.dart';
import 'package:rell_trader/model/active_trade_model.dart';
import 'package:rell_trader/model/trade_history_model.dart';
import 'package:rell_trader/model/trade_model.dart';
import 'package:rell_trader/view/widget/trade_details_row_widget.dart';

class TradeDetailsPage extends StatelessWidget {
  const TradeDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TradeController tradeController = Get.put(TradeController());
    TradeSignalModel currentSelectedTrade = tradeController
        .tempTradeModel[tradeController.currentSelectedTradeModelIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trade Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        shadowColor: currentSelectedTrade is ActiveTradeModel
            ? Colors.grey
            : currentSelectedTrade is TradeHistoryModel
                ? (currentSelectedTrade).response.toUpperCase() == 'PROFIT'
                    ? Colors.green
                    : Colors.red
                : Colors.grey,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12).copyWith(bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                currentSelectedTrade.symbol,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TradeDetailsRowWidget(
                label: 'Trade Condition',
                labelColor: Colors.grey,
                bodyColor: Colors.grey,
                bodyFontWeight: FontWeight.w500,
                labelFontWeight: FontWeight.w500,
                body: currentSelectedTrade.tradeCondition,
              ),
              const SizedBox(height: 10),
              TradeDetailsRowWidget(
                label: 'Trade Status',
                labelColor: Colors.grey,
                bodyColor: currentSelectedTrade is ActiveTradeModel
                    ? Colors.green
                    : Colors.grey,
                bodyFontWeight: FontWeight.w500,
                labelFontWeight: FontWeight.w500,
                body: currentSelectedTrade is ActiveTradeModel
                    ? 'Active Trade'
                    : 'Trade Expired',
              ),
              const SizedBox(height: 10),
              TradeDetailsRowWidget(
                label: 'Opening Time',
                labelColor: Colors.grey,
                bodyColor: Colors.grey,
                fontSize: 16,
                bodyFontWeight: FontWeight.w400,
                labelFontWeight: FontWeight.w400,
                body: currentSelectedTrade.createdAt,
              ),
              const SizedBox(height: 10),
              TradeDetailsRowWidget(
                label: 'Trade Result',
                labelColor: Colors.grey,
                bodyColor: currentSelectedTrade.response.toUpperCase() ==
                        'WAITING'
                    ? Colors.grey
                    : currentSelectedTrade.response.toUpperCase() == 'PROFIT'
                        ? Colors.green
                        : Colors.red,
                fontSize: 16,
                bodyFontWeight: FontWeight.w400,
                labelFontWeight: FontWeight.w500,
                body: currentSelectedTrade.response.toUpperCase(),
              ),
              const SizedBox(height: 10),
              TradeDetailsRowWidget(
                label: 'Opening Price',
                labelColor: Colors.grey,
                bodyColor: Colors.grey,
                fontSize: 16,
                bodyFontWeight: FontWeight.w400,
                labelFontWeight: FontWeight.w400,
                body: currentSelectedTrade.openPrice.toStringAsFixed(2),
              ),
              // currentSelectedTrade is ActiveTradeModel
              //     ? Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           const SizedBox(height: 10),
              //           Obx(
              //             () => TradeDetailsRowWidget(
              //               label: 'Current Price',
              //               labelColor: Colors.grey,
              //               bodyColor: Colors.grey,
              //               fontSize: 16,
              //               bodyFontWeight: FontWeight.w400,
              //               labelFontWeight: FontWeight.w400,
              //               body: (tradeController.tempTradeModel[
              //                           tradeController
              //                               .currentSelectedTradeModelIndex]
              //                       as ActiveTradeModel)
              //                   .currentPrice
              //                   .toStringAsFixed(2),
              //             ),
              //           ),
              //         ],
              //       )
              //     : const SizedBox(),
              const SizedBox(height: 10),
              TradeDetailsRowWidget(
                label: 'Stop Loss',
                labelColor: Colors.grey,
                bodyColor: Colors.red,
                fontSize: 16,
                bodyFontWeight: FontWeight.w400,
                labelFontWeight: FontWeight.w400,
                body: currentSelectedTrade.stopLoss.toStringAsFixed(2),
              ),
              const SizedBox(height: 10),
              TradeDetailsRowWidget(
                label: 'Take Profit',
                labelColor: Colors.grey,
                bodyColor: Colors.green,
                fontSize: 16,
                bodyFontWeight: FontWeight.w400,
                labelFontWeight: FontWeight.w400,
                body: currentSelectedTrade.takeProfit.toStringAsFixed(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

