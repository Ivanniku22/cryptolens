
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/coin_details_controller.dart';

class CoinDetailsView extends GetView<CoinDetailsController> {
  const CoinDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
              () => Text(
            controller.coin.value?.name ?? 'Coin Details',
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
            child: Text(controller.errorMessage.value),
          );
        }

        final coin = controller.coin.value;

        if (coin == null) {
          return const Center(
            child: Text('No coin data available.'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                coin.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                coin.symbol.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                '\$${coin.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              const Text(
                'Market Statistics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _statRow('Market Cap', coin.marketCap),
              _statRow('24h Volume', coin.volume24h),
              _statRow(
                '24h Change',
                coin.percentChange24h,
                isPercentage: true,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _statRow(
      String label,
      double value, {
        bool isPercentage = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            isPercentage
                ? '${value.toStringAsFixed(2)}%'
                : '\$${value.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}
