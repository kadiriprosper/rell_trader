import 'package:intl/intl.dart';
import 'package:rell_trader/model/trade_model.dart';

class ActiveTradeModel extends TradeSignalModel {
  ActiveTradeModel({
    required super.symbol,
    required super.tradeCondition,
    required super.stopLoss,
    required super.takeProfit,
    required super.openPrice,
    // required this.lotSize,
    required this.currentPrice,
    required super.response,
    required super.createdAt,
  });
  // double lotSize;
  double currentPrice;

  @override
  String get createdAt {
    try {
      return '${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.parse(super.createdAt))}:${DateFormat(DateFormat.HOUR_MINUTE).format(DateTime.parse(super.createdAt))}';
    } catch (_) {
      return 'error';
    }
  }

  factory ActiveTradeModel.fromMap(Map<String, dynamic> data) {
    return ActiveTradeModel(
      symbol: data['symbol'],
      tradeCondition: (data['trade_type'] as String).toUpperCase(),
      createdAt: DateTime.now().toString(),
      stopLoss: data['stop_loss'],
      takeProfit: data['take_profit'],
      openPrice: data['open_price'],
      // lotSize: data['lot_size'],
      response: 'Waiting',
      currentPrice: data['curent_price'],
    );
  }
}
