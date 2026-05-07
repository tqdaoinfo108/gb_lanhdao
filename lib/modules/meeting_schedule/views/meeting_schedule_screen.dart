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
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
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

  Get.find<MeetingScheduleController>().deleteMeeting(
    sectionTitle: sectionTitle,
    meetingIndex: meetingIndex,
  );
  Get.snackbar(
    'meeting.delete.success_title'.tr,
    'meeting.delete.success_content'.tr,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
  );
}
}
