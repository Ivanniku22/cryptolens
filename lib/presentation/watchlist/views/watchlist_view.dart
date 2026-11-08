
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/utils/price_formatter.dart';
import '../controller/watchlist_controller.dart';

class WatchlistView extends GetView<WatchlistController> {
  const WatchlistView({super.key});

  static const Color backgroundColor = Color(0xFF0D1117);
  static const Color cardColor = Color(0xFF151A1E);
  static const Color borderColor = Color(0xFF252D33);
  static const Color greenColor = Color(0xFF00C853);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Watchlist',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadWatchlistCoins,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.watchlistIds.isEmpty) {
          return _buildEmptyState();
        }

        if (controller.watchlistCoins.isEmpty) {
          return const Center(
            child: Text(
              'No coin data available.',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadWatchlistCoins,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.watchlistCoins.length,
            separatorBuilder: (_, _) =>
            const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final coin = controller.watchlistCoins[index];
              final isPositive = coin.percentChange24h >= 0;

              return InkWell(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.coinDetails,
                    arguments: coin.id,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: borderColor,
                        child: Text(
                          coin.symbol.length > 3
                              ? coin.symbol.substring(0, 3)
                              : coin.symbol,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coin.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              coin.symbol.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            PriceFormatter.format(coin.price),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${isPositive ? '+' : ''}${coin.percentChange24h.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: isPositive
                                  ? greenColor
                                  : Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          controller.removeFromWatchlist(coin.id);
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        ),
                        tooltip: 'Remove from Watchlist',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.white38,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your watchlist is empty',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your favourite cryptocurrencies '
                  'to keep track of them here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
