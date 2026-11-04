
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Market'),
        centerTitle: true,
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
                Text(controller.errorMessage.value),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.fetchCoins,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.coins.isEmpty) {
          return const Center(
            child: Text('No cryptocurrencies found.'),
          );
        }

        return ListView.builder(
          itemCount: controller.coins.length,
          itemBuilder: (context, index) {
            final coin = controller.coins[index];

            return ListTile(
              leading: CircleAvatar(
                child: Text(coin.symbol),
              ),
              title: Text(coin.name),
              subtitle: Text(coin.symbol),
              trailing: Text(
                '\$${coin.price.toStringAsFixed(2)}',
              ),
            );
          },
        );
      }),
    );
  }
}
