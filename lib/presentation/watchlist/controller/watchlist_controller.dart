
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/coin_model.dart';
import '../../../data/repository/coin_repository.dart';

class WatchlistController extends GetxController {
  final GetStorage _storage = GetStorage();
  final CoinRepository _repository = Get.find<CoinRepository>();

  static const String _storageKey = 'watchlist';

  final RxList<String> watchlistIds = <String>[].obs;
  final RxList<CoinModel> watchlistCoins = <CoinModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadWatchlist();
    loadWatchlistCoins();
  }

  void loadWatchlist() {
    final savedIds = _storage.read<List>(_storageKey);

    if (savedIds != null) {
      watchlistIds.assignAll(savedIds.cast<String>());
    }
  }

  Future<void> loadWatchlistCoins() async {
    if (watchlistIds.isEmpty) {
      watchlistCoins.clear();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final allCoins = await _repository.getCoins();

      watchlistCoins.assignAll(
        allCoins.where((coin) => watchlistIds.contains(coin.id)),
      );
    } catch (e) {
      errorMessage.value =
      'Failed to load watchlist. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToWatchlist(String coinId) async {
    if (watchlistIds.contains(coinId)) return;

    watchlistIds.add(coinId);
    _saveWatchlist();

    try {
      final coin = await _repository.getCoinById(coinId);

      if (watchlistIds.contains(coinId) &&
          !watchlistCoins.any((item) => item.id == coinId)) {
        watchlistCoins.add(coin);
      }
    } catch (e) {
      errorMessage.value = 'Could not load the selected coin.';
    }
  }

  void removeFromWatchlist(String coinId) {
    watchlistIds.remove(coinId);
    watchlistCoins.removeWhere((coin) => coin.id == coinId);
    _saveWatchlist();
  }

  bool isInWatchlist(String coinId) {
    return watchlistIds.contains(coinId);
  }

  Future<void> toggleWatchlist(String coinId) async {
    if (isInWatchlist(coinId)) {
      removeFromWatchlist(coinId);
    } else {
      await addToWatchlist(coinId);
    }
  }

  void _saveWatchlist() {
    _storage.write(_storageKey, watchlistIds.toList());
  }
}
