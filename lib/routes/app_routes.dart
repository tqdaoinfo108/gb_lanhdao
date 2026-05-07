/// Tất cả route name định nghĩa ở đây.
/// Sử dụng: Get.toNamed(AppRoutes.home)
abstract class AppRoutes {
  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------
  static const splash = '/splash';
  static const login  = '/login';

  // ---------------------------------------------------------------------------
  // Main
  // ---------------------------------------------------------------------------
  static const home = '/home';
  static const tasks = '/tasks';
  static const taskDetail = '/task-detail';

  // ---------------------------------------------------------------------------
  // Thêm route mới vào đây khi tạo module mới
  // Ví dụ:
  // static const kpiDetail = '/kpi-detail';
  // static const profile   = '/profile';
  // ---------------------------------------------------------------------------
}
