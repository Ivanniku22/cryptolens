
import 'package:get/get.dart';
import '../../../data/models/coin_model.dart';
import '../../../data/repository/coin_repository.dart';

class HomeController extends GetxController {
  final CoinRepository _repository = Get.find<CoinRepository>();

  static const int pageSize = 20;

  final RxList<CoinModel> coins = <CoinModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  final List<CoinModel> _allCoins = [];

  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchCoins();
  }

  Future<void> fetchCoins() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getCoins();
      print('Total coins fetched: ${result.length}');

      _allCoins
        ..clear()
        ..addAll(result);

      coins.assignAll(_allCoins.take(pageSize));

      hasMore = coins.length < _allCoins.length;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void loadMoreCoins() {
    if (isLoadingMore.value || !hasMore) return;

    isLoadingMore.value = true;

    final start = coins.length;
    final remaining = _allCoins.length - start;
    final count = remaining < pageSize ? remaining : pageSize;
    final end = start + count;

    coins.addAll(_allCoins.sublist(start, end));
    print('Coins currently displayed: ${coins.length}');

    hasMore = end < _allCoins.length;

    isLoadingMore.value = false;
  }
}
