import 'package:get/get.dart';

import '../core/utils/auth_helper.dart';
import '../modules/api_test/api_test_screen.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static String get initial => AuthHelper.hasToken()
      ? AppRoutes.home
      : AppRoutes.login;

  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.apiTest,
      page: () => const ApiTestScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
