
import 'package:get/get.dart';

import '../../presentation/home/bindings/home_binding.dart';
import '../../presentation/home/views/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
