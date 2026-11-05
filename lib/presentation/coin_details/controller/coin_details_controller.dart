import 'package:get/get.dart';
import '../../../data/models/coin_model.dart';
import '../../../data/repository/coin_repository.dart';

class CoinDetailsController extends GetxController {
  final CoinRepository _repository = Get.find<CoinRepository>();

  final Rxn<CoinModel> coin = Rxn<CoinModel>();
  final RxMap<String, dynamic> details = <String, dynamic>{}.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

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
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
