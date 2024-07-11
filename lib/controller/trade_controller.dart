import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:rell_trader/controller/user_controller.dart';
import 'package:rell_trader/model/trade_history_model.dart';
import 'package:rell_trader/model/trade_model.dart';
import 'package:rell_trader/view/main_screens/widgets/signal_card_widget.dart';

const String serverUrl = String.fromEnvironment('baseUrl');

const String webSocketUrl = String.fromEnvironment('webSocket');
const String tradeHistoryApi = '$serverUrl/trade/history/';

///This Controller Class holds all the logic for initializing, receiving, parsing and passing
///the trade signals from one screen to the other.
class TradeController extends GetxController {
  RxList<SignalCardWidget> tradingSignals = <SignalCardWidget>[].obs;

  RxList<TradeHistoryModel> tradeHistoryList = <TradeHistoryModel>[].obs;
  RxList<TradeSignalModel> tradingSignalModels = <TradeSignalModel>[].obs;
  RxList<TradeSignalModel> tempTradeModel = <TradeSignalModel>[].obs;

  int currentSelectedTradeModelIndex = 0;

  late Rx<TradeSignalModel> currentSelectedSignal;

  late Stream streamController;

  ///Launches the connection to the web socket api
  void openConnection() {
    try {
      final channel = WebSocketChannel.connect(
        Uri.parse(webSocketUrl),
      );
      channel.sink.add(jsonEncode({"msg": "ping"}));
      streamController = channel.stream;
    } catch (_) {}
  }

  @override
  void onInit() async {
    await initTradingSignals();
    super.onInit();
  }

  ///Initializes all the trading signals
  Future<void> initTradingSignals() async {
    //Clears [tradingSignals] if its not empty so as not to have duplicate data
    if (tradingSignals.isNotEmpty) {
      tradingSignals.clear();
    }
    tradingSignalModels.clear();

    await getTradeHistory();
    int i = 0;
    if (tradeHistoryList.isNotEmpty) {
      // Creates a trade card widget and then stores it in the trading signals
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

  /// Adds [signalCardWidget] to [tradingSignals] list
  void addTradingSignal(SignalCardWidget signalCardWidget) {
    tradingSignals.add(signalCardWidget);
  }

  /// Calls the [tradeHistoryApi] and gets all the trade history available
  ///
  /// Adds this history to the [tradeHistoryList]
  Future<bool> getTradeHistory() async {
    UserController userController = Get.put(UserController());
    try {
      http.Response response = await http.get(
        Uri.parse(tradeHistoryApi),
        headers: {
          'Authorization': userController.token,
        },
      );
      Map<String, dynamic> totalHistory = jsonDecode(response.body);
      if (tradeHistoryList.isNotEmpty) {
        tradeHistoryList.clear();
        tradingSignalModels.clear();
      }
      if (totalHistory['status'] == 200) {
        int i = 0;
        // print('Getting First Data');
        // print(totalHistory['data']);
        // print('First Data Gotten');
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
      // print(tradeHistoryList);
      return true;
    } on http.ClientException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    return false;
  }
}
