
import 'package:get/get.dart';
import '../../../data/models/coin_model.dart';
import '../../../data/repository/coin_repository.dart';

class HomeController extends GetxController {
  final CoinRepository _repository = Get.find<CoinRepository>();

  final RxList<CoinModel> coins = <CoinModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

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

      coins.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
