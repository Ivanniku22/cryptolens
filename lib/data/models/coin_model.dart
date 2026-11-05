class CoinModel {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final double marketCap;
  final double volume24h;
  final double percentChange24h;

  // Supply information
  final double? circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;

  CoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.marketCap,
    required this.volume24h,
    required this.percentChange24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
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
      percentChange24h: (usd['percent_change_24h'] as num?)?.toDouble() ?? 0.0,

      // Supply fields
      circulatingSupply: (json['circulating_supply'] as num?)?.toDouble(),
      totalSupply: (json['total_supply'] as num?)?.toDouble(),
      maxSupply: (json['max_supply'] as num?)?.toDouble(),
    );
  }
}
