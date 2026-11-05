
import 'package:get/get.dart';

import '../../../data/models/coin_model.dart';
import '../../../data/models/historical_price_model.dart';
import '../../../data/repository/coin_repository.dart';

class CoinDetailsController extends GetxController {
  final CoinRepository _repository = Get.find<CoinRepository>();

  final Rxn<CoinModel> coin = Rxn<CoinModel>();
  final RxMap<String, dynamic> details = <String, dynamic>{}.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Chart state
  final RxList<HistoricalPriceModel> historicalPrices =
      <HistoricalPriceModel>[].obs;

  final RxBool isChartLoading = false.obs;
  final RxString chartError = ''.obs;
  final RxString selectedRange = '1D'.obs;

  final List<String> timeRanges = [
    '1D',
    '1W',
    '1M',
    '6M',
    '1Y',
  ];

  @override
  void onInit() {
    super.onInit();

    final coinId = Get.arguments as String?;

    if (coinId != null) {
      loadCoin(coinId);
    } else {
      errorMessage.value = 'No coin ID provided.';
    }
  }

  Future<void> loadCoin(String coinId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final coinData = await _repository.getCoinById(coinId);
      final detailsData = await _repository.getCoinDetails(coinId);

      coin.value = coinData;
      details.assignAll(detailsData);

      // Load the initial chart data.
      await loadHistoricalPrices();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadHistoricalPrices() async {
    final coinId = coin.value?.id;

    if (coinId == null) return;

    try {
      isChartLoading.value = true;
      chartError.value = '';

      final range = selectedRange.value;

      final Duration duration;
      final String interval;

      switch (range) {
        case '1D':
          duration = const Duration(hours: 24);
          interval = '1h';
          break;

        case '1W':
          duration = const Duration(days: 7);
          interval = '1d';
          break;

        case '1M':
          duration = const Duration(days: 30);
          interval = '1d';
          break;

        case '6M':
          duration = const Duration(days: 180);
          interval = '1d';
          break;

        case '1Y':
          duration = const Duration(days: 365);
          interval = '1d';
          break;

        default:
          duration = const Duration(hours: 24);
          interval = '1h';
      }

      final startDate = DateTime.now()
          .toUtc()
          .subtract(duration)
          .toIso8601String();

      final prices = await _repository.getHistoricalPrices(
        coinId,
        start: startDate,
        interval: interval,
      );

      historicalPrices.assignAll(prices);

      if (prices.isEmpty) {
        chartError.value = 'No historical price data available.';
      }
    } catch (e) {
      chartError.value = e.toString();
      historicalPrices.clear();
    } finally {
      isChartLoading.value = false;
    }
  }

  void changeTimeRange(String range) {
    if (selectedRange.value == range) return;

    selectedRange.value = range;
    loadHistoricalPrices();
  }
}
