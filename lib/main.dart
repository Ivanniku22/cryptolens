import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/app_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Crypto Market',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.routes,

      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C853),
          brightness: Brightness.dark,
          surface: const Color(0xFF151A1E),
        ),

        scaffoldBackgroundColor: const Color(0xFF0D1117),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1117),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),

        dividerColor: const Color(0xFF252D33),

        iconTheme: const IconThemeData(
          color: Colors.white70,
        ),
      ),
    );
  }
}
