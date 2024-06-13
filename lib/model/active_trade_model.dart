class ActiveTradeModel {
  ActiveTradeModel({
    required this.symbol,
    required this.tradeType,
    required this.stopLoss,
    required this.takeProfit,
    required this.openPrice,
    // required this.lotSize,
    required this.currentPrice,
  });
  String symbol;
  String tradeType;
  double stopLoss;
  double takeProfit;
  double openPrice;
  // double lotSize;
  double currentPrice;

  factory ActiveTradeModel.fromMap(Map<String, dynamic> data) {
    return ActiveTradeModel(
      symbol: data['symbol'],
      tradeType: data['trade_type'],
      stopLoss: data['stop_loss'],
      takeProfit: data['take_profit'],
      openPrice: data['open_price'],
      // lotSize: data['lot_size'],
      currentPrice: data[
          'curent_price'], //TODO: Tell Backend Chief to change the spelling to current not curent
    );
  }
}
