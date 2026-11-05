
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/utils/price_formatter.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CRYPTOLENS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Your crypto market overview',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white54,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: controller.fetchCoins,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh market',
          ),
          const SizedBox(width: 8),
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
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.fetchCoins,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.coins.isEmpty) {
          return const Center(
            child: Text('No cryptocurrencies found.'),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200) {
              controller.loadMoreCoins();
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 16,
            ),
            itemCount: controller.coins.length +
                (controller.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.coins.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final coin = controller.coins[index];
              final isPositive = coin.percentChange24h >= 0;

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF151A1E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF252D33),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.coinDetails,
                      arguments: coin.id,
                    );
                  },
                  child: Row(
                    children: [
                      // Coin symbol
                      CircleAvatar(
                        backgroundColor: const Color(0xFF252D33),
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

                      // Coin name and symbol
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coin.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
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

                      // Price and 24-hour percentage change
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            PriceFormatter.format(coin.price),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Percentage change indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isPositive
                                  ? const Color(0xFF00C853)
                                  .withOpacity(0.12)
                                  : Colors.redAccent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositive
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: isPositive
                                      ? const Color(0xFF00C853)
                                      : Colors.redAccent,
                                  size: 12,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${isPositive ? '+' : '-'}${coin.percentChange24h.abs().toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    color: isPositive
                                        ? const Color(0xFF00C853)
                                        : Colors.redAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
}
