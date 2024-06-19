import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rell_trader/model/trade_history_model.dart';
import 'package:rell_trader/model/trade_model.dart';
import 'package:rell_trader/view/main_screens/widgets/signal_card_widget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const String tradeHistoryApi = 'http://81.0.249.14:80/trade/history/';
const String freeSignalApi = 'ws://81.0.249.14:80/ws/check/free';

class TradeController extends GetxController {
  RxList<TradeHistoryModel> tradeHistoryList = <TradeHistoryModel>[].obs;
  RxList<SignalCardWidget> tradingSignals = <SignalCardWidget>[].obs;
  RxList<TradeSignalModel> tradingSignalModels = <TradeSignalModel>[].obs;
  late Rx<TradeSignalModel> currentSelectedSignal;

  // set currentSelectedSignal(TradeSignalModel currentModel) =>
  //     _currentSelectedSignal = currentModel.obs;

  // TradeSignalModel get currentSelectedSignal => _currentSelectedSignal.value;

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
    await initTradingSignals();
    super.onInit();
  }

  Future<void> initTradingSignals() async {
    //TODO: Test this guy
    if (tradingSignals.isNotEmpty) {
      tradingSignals.clear();
    }
    tradingSignalModels.clear();
    await getTradeHistory();
    int i = 0;
    if (tradeHistoryList.isNotEmpty) {
      while (i < tradeHistoryList.length) {
        final currentTrade = tradeHistoryList[i];

        //The free signals and the trade history signals use this widget
        final tradeWidget = FreeSignalCardWidget(
          tradingPair: currentTrade.symbol,
          condition: currentTrade.tradeCondition,
          dateCreated: currentTrade.createdAt,
          rsi: '',
          result: currentTrade.response,
          symbol: currentTrade.symbol,
          sma: currentTrade.stopLoss.toStringAsFixed(2),
          tp: currentTrade.takeProfit.toStringAsFixed(2),
          currentPrice: currentTrade.openPrice.toStringAsFixed(2),
        );
        addTradingSignal(tradeWidget);
        i++;
      }
    }
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
        tradingSignalModels.clear();
      }
      if (totalHistory['status'] == 200) {
        int i = 0;
        print('Getting First Data');
        print(totalHistory['data']);
        print('First Data Gotten');
        while (i < (totalHistory['data'] as List).length) {
          tradeHistoryList.add(
            TradeHistoryModel.fromMap(totalHistory['data'][i]),
          );
          tradingSignalModels.add(
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
