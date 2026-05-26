import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/meeting_schedule_controller.dart';
import 'widgets/meeting_bottom_nav_bar.dart';
import 'widgets/meeting_day_section.dart';
import 'widgets/meeting_dialogs.dart';
import 'widgets/meeting_header.dart';

class MeetingScheduleScreen extends GetView<MeetingScheduleController> {
  const MeetingScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Đang tải dữ liệu...'),
              ],
            ),
          );
        }

        // Error state
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Đã xảy ra lỗi',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.loadData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        }

        // Empty state
        if (controller.sections.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chưa có lịch họp nào',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nhấn nút + để tạo lịch họp mới',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Content
        return RefreshIndicator(
          onRefresh: controller.loadData,
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: MeetingHeader()),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => MeetingDaySection(
                          section: controller.sections[index],
                          addBottomSpacing: index < controller.sections.length - 1,
                          onTapMeeting: (meeting, meetingIndex) {
                            showMeetingDetailDialog(
                              context: context,
                              item: meeting,
                              onDeleteTap: () => _confirmAndDeleteMeeting(
                                context,
                                controller.sections[index].title,
                                meetingIndex,
                              ),
                            );
                          },
                          onDeleteMeeting: (meetingIndex) => _confirmAndDeleteMeeting(
                            context,
                            controller.sections[index].title,
                            meetingIndex,
                          ),
                        ),
                        childCount: controller.sections.length,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 18,
                bottom: 90,
                child: FloatingActionButton(
                  heroTag: 'meeting-create-right',
                  onPressed: () => showCreateMeetingDialog(
                    context: context,
                    controller: controller,
                  ),
                  backgroundColor: const Color(0xFF1A56DB),
                  elevation: 4,
                  child: const Icon(Icons.edit_calendar_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: const MeetingBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1A56DB),
        elevation: 3,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  Future<void> _confirmAndDeleteMeeting(
    BuildContext context,
    String sectionTitle,
    int meetingIndex,
  ) async {
    final confirmed = await showDeleteConfirmDialog(context);
    if (confirmed != true) return;

    try {
      await controller.deleteMeeting(
        sectionTitle: sectionTitle,
        meetingIndex: meetingIndex,
      );

      if (controller.errorMessage.isNotEmpty) {
        throw Exception(controller.errorMessage.value);
      }

      Get.snackbar(
        'meeting.delete.success_title'.tr,
        'meeting.delete.success_content'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xóa lịch họp: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
