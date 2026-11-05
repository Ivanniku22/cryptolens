
class PriceFormatter {
  static String format(double price) {
    if (price >= 1) {
      return '\$${price.toStringAsFixed(2)}';
    }

    if (price >= 0.01) {
      return '\$${price.toStringAsFixed(4)}';
    }

    if (price >= 0.0001) {
      return '\$${price.toStringAsFixed(6)}';
    }

    return '\$${price.toStringAsFixed(8)}';
  }
}
