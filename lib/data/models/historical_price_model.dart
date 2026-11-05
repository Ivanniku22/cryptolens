
class HistoricalPriceModel {
  final DateTime timestamp;
  final double price;

  HistoricalPriceModel({
    required this.timestamp,
    required this.price,
  });

  factory HistoricalPriceModel.fromJson(Map<String, dynamic> json) {
    return HistoricalPriceModel(
      timestamp: DateTime.parse(json['timestamp'] as String),
      price: (json['price'] as num).toDouble(),
    );
  }
}
