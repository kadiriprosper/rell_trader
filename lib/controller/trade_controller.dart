import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rell_trader/model/trade_history_model.dart';
import 'package:rell_trader/view/main_screens/widgets/signal_card_widget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const String tradeHistoryApi = 'http://81.0.249.14:80/trade/history/';
const String freeSignalApi = 'ws://81.0.249.14:80/ws/check/free';

class TradeController extends GetxController {
  RxList<TradeHistoryModel> tradeHistoryList = <TradeHistoryModel>[].obs;
  RxList<SignalCardWidget> tradingSignals = <SignalCardWidget>[].obs;

  
  late StreamController streamController;

  void openConnection() {
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://81.0.249.14:80/ws/check/premium'),
    );
    channel.sink.add(jsonEncode({"msg": "ping"}));
    streamController = StreamController.broadcast()..addStream(channel.stream);

  }

  @override
  void onInit() async {
    if (tradingSignals.isEmpty) {
      await getTradeHistory();
      int i = 0;
      if (tradeHistoryList.isNotEmpty) {
        while (i < tradeHistoryList.length) {
          final currentTrade = tradeHistoryList[i];

          //The free signals and the trade history signals use this widget
          final tradeWidget = FreeSignalCardWidget(
            tradingPair: currentTrade.symbol,
            condition: currentTrade.tradeCondition,
            dateCreated: currentTrade.createdDate,
            rsi: '',
            result: currentTrade.response,
            symbol: currentTrade.symbol,
            sma: currentTrade.stopLoss.toStringAsFixed(2),
            tp: currentTrade.takeProfit.toStringAsFixed(2),
            currentPrice: currentTrade.price.toStringAsFixed(2),
          );
          addTradingSignal(tradeWidget);
          i++;
        }
      }
    }
    super.onInit();
  }

  void addTradingSignal(SignalCardWidget signalCardWidget) {
    tradingSignals.add(signalCardWidget);
  }

  Future<bool> getTradeHistory() async {
    try {
      http.Response response = await http.get(
        Uri.parse(tradeHistoryApi),
      );
      Map<String, dynamic> totalHistory = jsonDecode(response.body);
      if (tradeHistoryList.isNotEmpty) {
        tradeHistoryList.clear();
      }
      if (totalHistory['status'] == 200) {
        int i = 0;
        print(totalHistory['data']);
        while (i < (totalHistory['data'] as List).length) {
          tradeHistoryList.add(
            TradeHistoryModel.fromMap(totalHistory['data'][i]),
          );
          i++;
        }
      }
      print(tradeHistoryList);
      return true;
    } on http.ClientException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Rx<double> _selectedMaximumRisk = 1.45.obs;
  // double get selectedMaximumRisk => _selectedMaximumRisk.value;

  // set selectedMaximumRisk(double maxRisk) {
  //   _selectedMaximumRisk.value = maxRisk;
  // }
}
