
import 'package:get/get.dart';

import '../../presentation/coin_details/bindings/coin_details_binding.dart';
import '../../presentation/coin_details/view/coin_details_view.dart';
import '../../presentation/home/bindings/home_binding.dart';
import '../../presentation/main/view/main_view.dart';
import '../../presentation/watchlist/views/watchlist_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const MainView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.coinDetails,
      page: () => const CoinDetailsView(),
      binding: CoinDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.watchlist,
      page: () => const WatchlistView(),
    ),
  ];
}
