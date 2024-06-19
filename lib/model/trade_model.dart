enum TradeCondition {
  buy,
  sell,
}

abstract class TradeSignalModel {
  TradeSignalModel({
    required this.symbol,
    required this.openPrice,
    required this.response,
    required this.stopLoss,
    required this.takeProfit,
    required this.tradeCondition,
    required this.createdAt,
  });
  String symbol;
  double openPrice;
  double stopLoss;
  double takeProfit;
  String response;
  String tradeCondition;
  String createdAt;

}

// class TradeModel extends TradeSignalModel {
//   TradeModel({
//     required this.status,
//     required this.condition,
//     required this.rsi,
//     required this.sl,
//     required this.tp,
//     required this.currentPrice,
//   });
//   bool status;
//   TradeCondition condition;
//   double rsi;
//   double sl;
//   double tp;
//   double currentPrice;

//   factory TradeModel.fromMap(Map<String, dynamic> data) {
//     return TradeModel(
//       status: data['status'],
//       condition: data['condition'].toString().toUpperCase() == 'BUY'
//           ? TradeCondition.buy
//           : TradeCondition.sell,
//       rsi: data['RSI'],
//       sl: data['SL'],
//       tp: data['TP'],
//       currentPrice: data['Current Price'],
//     );
//   }
// }
