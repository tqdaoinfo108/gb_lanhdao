import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_screen.dart';
import 'app_routes.dart';

/// Đăng ký tất cả GetPage ở đây.
/// Khi thêm module mới, thêm GetPage tương ứng vào list này.
class AppPages {
  AppPages._();

  static const initial = AppRoutes.home;

  static final pages = [
    // ------------------------------------------------------------------
    // Home
    // ------------------------------------------------------------------
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),

    // ------------------------------------------------------------------
    // Thêm GetPage mới vào đây
    // Ví dụ:
    // GetPage(
    //   name: AppRoutes.kpiDetail,
    //   page: () => const KpiDetailScreen(),
    //   binding: KpiDetailBinding(),
    // ),
    // ------------------------------------------------------------------
  ];
}
