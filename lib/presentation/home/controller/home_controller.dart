
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/models/coin_model.dart';
import '../../../data/repository/coin_repository.dart';

enum CoinSortOption {
  marketCap,
  price,
  gainers,
  losers,
}

class HomeController extends GetxController {
  final CoinRepository _repository = Get.find<CoinRepository>();

  final TextEditingController searchTextController =
  TextEditingController();

  static const int pageSize = 20;

  final RxList<CoinModel> coins = <CoinModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  final Rx<CoinSortOption> sortOption =
      CoinSortOption.marketCap.obs;

  final List<CoinModel> _allCoins = [];
  List<CoinModel> _filteredCoins = [];

  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchCoins();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> fetchCoins() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getCoins();

      _allCoins
        ..clear()
        ..addAll(result);

      _applyFiltersAndSort();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void searchCoins(String query) {
    searchQuery.value = query;
    _applyFiltersAndSort();
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    _applyFiltersAndSort();
  }

  void changeSortOption(CoinSortOption option) {
    sortOption.value = option;
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) {
      _filteredCoins = List.from(_allCoins);
    } else {
      _filteredCoins = _allCoins.where((coin) {
        return coin.name.toLowerCase().contains(query) ||
            coin.symbol.toLowerCase().contains(query);
      }).toList();
    }

    switch (sortOption.value) {
      case CoinSortOption.marketCap:
        _filteredCoins.sort(
              (a, b) => b.marketCap.compareTo(a.marketCap),
        );
        break;

      case CoinSortOption.price:
        _filteredCoins.sort(
              (a, b) => b.price.compareTo(a.price),
        );
        break;

      case CoinSortOption.gainers:
        _filteredCoins.sort(
              (a, b) => b.percentChange24h.compareTo(
            a.percentChange24h,
          ),
        );
        break;

      case CoinSortOption.losers:
        _filteredCoins.sort(
              (a, b) => a.percentChange24h.compareTo(
            b.percentChange24h,
          ),
        );
        break;
    }

    coins.assignAll(_filteredCoins.take(pageSize));
    hasMore = coins.length < _filteredCoins.length;
  }

  void loadMoreCoins() {
    if (isLoadingMore.value || !hasMore) return;

    isLoadingMore.value = true;

    final start = coins.length;
    final remaining = _filteredCoins.length - start;
    final count = remaining < pageSize ? remaining : pageSize;
    final end = start + count;

    coins.addAll(_filteredCoins.sublist(start, end));

    hasMore = end < _filteredCoins.length;

    isLoadingMore.value = false;
  }
}
