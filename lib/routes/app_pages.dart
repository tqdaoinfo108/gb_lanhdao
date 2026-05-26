import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_screen.dart';
import '../modules/tasks/bindings/tasks_binding.dart';
import '../modules/tasks/views/tasks_screen.dart';
import '../modules/tasks/bindings/task_detail_binding.dart';
import '../modules/tasks/views/task_detail_screen.dart';
import '../modules/meeting_schedule/bindings/meeting_schedule_binding.dart';
import '../modules/meeting_schedule/views/meeting_schedule_screen.dart';
import '../modules/api_test/api_test_screen.dart';
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
    // Tasks (Giao việc)
    // ------------------------------------------------------------------
    GetPage(
      name: AppRoutes.tasks,
      page: () => const TasksScreen(),
      binding: TasksBinding(),
      transition: Transition.fadeIn,
    ),

    // ------------------------------------------------------------------
    // Task Detail (Chi tiết công việc)
    // ------------------------------------------------------------------
    GetPage(
      name: AppRoutes.taskDetail,
      page: () => const TaskDetailScreen(),
      binding: TaskDetailBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.meetingSchedule,
      page: () => const MeetingScheduleScreen(),
      binding: MeetingScheduleBinding(),
      transition: Transition.rightToLeft,
    ),

    // ------------------------------------------------------------------
    // Dev/Test
    // ------------------------------------------------------------------
    GetPage(
      name: AppRoutes.apiTest,
      page: () => const ApiTestScreen(),
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
