import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gb_lanhdao/modules/tasks/controllers/tasks_controller.dart';
import 'package:gb_lanhdao/modules/tasks/views/widgets/task_card_widget.dart';
import 'package:gb_lanhdao/modules/tasks/views/widgets/search_bar_widget.dart';
import 'package:gb_lanhdao/widgets/app_bottom_navigation.dart';
import 'package:gb_lanhdao/routes/app_routes.dart';
import 'package:gb_lanhdao/data/models/task_model.dart';

import 'package:gb_lanhdao/modules/tasks/views/widgets/add_task_dialog.dart';

class TasksScreen extends GetView<TasksController> {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FD),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: Get.back,
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF6B7280)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Giao việc & KPI',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F1724),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          // ✅ GIẢI PHÁP: Sử dụng showDialog tiêu chuẩn với useRootNavigator: false
                          // Tránh lỗi rendering assertion "Assertion failed: !_debugDuringDeviceUpdate"
                          // khi GetX cố gắng cập nhật UI đồng thời với việc mở dialog.
                          showDialog(
                            context: context,
                            useRootNavigator: false, // Tránh xung đột với Root Navigator
                            barrierDismissible: true,
                            barrierColor: Colors.black.withValues(alpha: 0.3), // Hiệu ứng overlay chuẩn
                            builder: (context) => const AddTaskDialog(),
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFEAF1FF), Color(0xFFD9E8FF)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2F80ED).withOpacity(0.10),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.add, size: 26, color: Color(0xFF2F6CE1)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: Obx(() {
                      // Truy cập các biến reactive ở đây để Obx đăng ký lắng nghe thay đổi
                      final selectedType = controller.selectedTabType.value;
                      final _ = controller.tasks.length; // Để cập nhật số lượng (count) trên tab khi dữ liệu thay đổi

                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: controller.tabTypes.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 6),
                        itemBuilder: (context, index) {
                          final type = controller.tabTypes[index];
                          return _FilterChip(
                            label: controller.getTabLabel(type),
                            isSelected: selectedType == type,
                            onTap: () => controller.setSelectedTab(type),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            Container(
              height: 8,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(14, 12, 14, 0),
                    child: SearchBarWidget(),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final List<Task> data = controller.filteredTasks;
                      if (data.isEmpty) {
                        return const Center(
                          child: Text(
                            'Không có công việc nào',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 96),
                        itemCount: data.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => TaskCardWidget(
                          task: data[index],
                          onDelete: () => controller.deleteTask(data[index].id),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: 1,
        onHomeTap: () => Get.offAllNamed(AppRoutes.home),
        onTasksTap: () {},
        onChatTap: () {},
        onProfileTap: () {},
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2F6CE1) : const Color(0xFFF2F5FA),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: isSelected ? const Color(0xFF2F6CE1) : const Color(0xFFD8DEE8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.06 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
