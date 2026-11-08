import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../data/repository/coin_repository.dart';
import '../../presentation/watchlist/controller/watchlist_controller.dart';
import '../../services/coin_paprika_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Dio>(
          () => Dio(
        BaseOptions(
          baseUrl: 'http://192.168.1.2:3000/api',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ),
    );

    Get.lazyPut<CoinPaprikaService>(
          () => CoinPaprikaService(Get.find<Dio>()),
    );

    Get.lazyPut<CoinRepository>(
          () => CoinRepository(Get.find<CoinPaprikaService>()),
    );

    Get.lazyPut<WatchlistController>(
          () => WatchlistController(),
      fenix: true,
    );
  }
}
