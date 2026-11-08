
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/price_formatter.dart';
import '../../watchlist/controller/watchlist_controller.dart';
import '../controller/coin_details_controller.dart';
import '../widgets/price_chart.dart';

class CoinDetailsView extends GetView<CoinDetailsController> {
  const CoinDetailsView({super.key});

  static const Color backgroundColor = Color(0xFF0D1117);
  static const Color cardColor = Color(0xFF151A1E);
  static const Color borderColor = Color(0xFF252D33);
  static const Color greenColor = Color(0xFF00C853);

  @override
  Widget build(BuildContext context) {

    final watchlistController = Get.find<WatchlistController>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Obx(
              () => Text(
            controller.coin.value?.name ?? 'Coin Details',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Obx(() {
            final coinId = controller.coin.value?.id;
            final isSaved = coinId != null &&
                watchlistController.isInWatchlist(coinId);

            return IconButton(
              onPressed: coinId == null
                  ? null
                  : () {
                watchlistController.toggleWatchlist(coinId);
              },
              icon: Icon(
                isSaved ? Icons.favorite : Icons.favorite_border,
                color: isSaved ? Colors.redAccent : Colors.white,
              ),
              tooltip: isSaved
                  ? 'Remove from Watchlist'
                  : 'Add to Watchlist',
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final coinId = controller.coin.value?.id;
                      if (coinId != null) {
                        controller.loadCoin(coinId);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final coin = controller.coin.value;

        if (coin == null) {
          return const Center(
            child: Text('No coin data available.'),
          );
        }

        final isPositive = coin.percentChange24h >= 0;

        final description =
            controller.details['description']?.toString() ?? '';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coin identity
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: borderColor,
                    child: Text(
                      coin.symbol.length > 3
                          ? coin.symbol.substring(0, 3)
                          : coin.symbol,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coin.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          coin.symbol.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Current price
              const Text(
                'CURRENT PRICE',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.3,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                PriceFormatter.format(coin.price),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),

              const SizedBox(height: 12),

              // 24-hour change indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isPositive
                      ? greenColor.withValues(alpha: 0.12)
                      : Colors.redAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: isPositive
                          ? greenColor
                          : Colors.redAccent,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${isPositive ? '+' : '-'}${coin.percentChange24h.abs().toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: isPositive
                            ? greenColor
                            : Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      '24h',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Historical price chart
              PriceChart(
                prices: controller.historicalPrices.toList(),
                selectedRange: controller.selectedRange.value,
                timeRanges: controller.timeRanges,
                isLoading: controller.isChartLoading.value,
                errorMessage: controller.chartError.value,
                onRangeChanged: controller.changeTimeRange,
              ),

              const SizedBox(height: 30),

              // Market statistics
              const Text(
                'Market Statistics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              // Statistics card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: borderColor,
                  ),
                ),
                child: Column(
                  children: [
                    _statRow(
                      'Market Cap',
                      _formatCurrency(coin.marketCap),
                    ),
                    _statDivider(),
                    _statRow(
                      '24h Volume',
                      _formatCurrency(coin.volume24h),
                    ),
                    _statDivider(),
                    _statRow(
                      '24h Change',
                      '${coin.percentChange24h >= 0 ? '+' : ''}${coin.percentChange24h.toStringAsFixed(2)}%',
                      valueColor: isPositive
                          ? greenColor
                          : Colors.redAccent,
                    ),
                    _statDivider(),
                    _statRow(
                      'Total Supply',
                      _formatSupply(coin.totalSupply, coin.symbol),
                    ),
                    _statDivider(),
                    _statRow(
                      'Max Supply',
                      _formatSupply(coin.maxSupply, coin.symbol),
                    ),
                  ],
                ),
              ),

              // Coin description
              if (description.trim().isNotEmpty) ...[
                const SizedBox(height: 30),
                const Text(
                  'About',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
              ],

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _statRow(
      String label,
      String value, {
        Color valueColor = Colors.white,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: valueColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statDivider() {
    return const Divider(
      color: borderColor,
      height: 1,
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(2)}B';
    }

    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    }

    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(2)}K';
    }

    return '\$${value.toStringAsFixed(2)}';
  }

  String _formatSupply(double? value, String symbol) {
    if (value == null || value <= 0) {
      return 'N/A';
    }

    String formatted;

    if (value >= 1000000000) {
      formatted = '${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value >= 1000000) {
      formatted = '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      formatted = '${(value / 1000).toStringAsFixed(2)}K';
    } else {
      formatted = value.toStringAsFixed(2);
    }

    return '$formatted $symbol';
  }
}
