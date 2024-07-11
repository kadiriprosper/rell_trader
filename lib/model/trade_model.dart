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