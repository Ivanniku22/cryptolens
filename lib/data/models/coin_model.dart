
class CoinModel {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final double marketCap;
  final double volume24h;
  final double percentChange24h;

  CoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.marketCap,
    required this.volume24h,
    required this.percentChange24h,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    final usd = json['quotes']['USD'];

    return CoinModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      price: (usd['price'] as num).toDouble(),
      marketCap: (usd['market_cap'] as num).toDouble(),
      volume24h: (usd['volume_24h'] as num).toDouble(),
      percentChange24h:
      (usd['percent_change_24h'] as num).toDouble(),
    );
  }
}
