import 'package:get/get.dart';
import '../../../data/mock/meeting_schedule_mock_data.dart';
import '../../../data/models/meeting_schedule_models.dart';

/// Controller cho màn hình lịch họp.
class MeetingScheduleController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<MeetingScheduleSection> sections = <MeetingScheduleSection>[].obs;

  String get headerTitle => MeetingScheduleMockData.headerTitle;
  String get headerDate => MeetingScheduleMockData.headerDate;
  List<String> get locationOptions => MeetingScheduleMockData.locationOptions;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await Future.delayed(const Duration(milliseconds: 250));
      sections.assignAll(MeetingScheduleMockData.sections);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void addMeeting({
    required DateTime date,
    required String time,
    required String title,
    required String location,
    required String duration,
    String? organizer,
  }) {
    final sectionTitle = _buildSectionTitle(date);
    final targetIndex = sections.indexWhere((s) => s.title == sectionTitle);

    final baseMeetings = targetIndex == -1 ? <MeetingScheduleItem>[] : sections[targetIndex].meetings;
    final updatedMeetings = <MeetingScheduleItem>[
      ...baseMeetings,
      MeetingScheduleItem(
        time: time,
        title: title,
        location: location,
        duration: duration,
        organizer: organizer,
        statusLabel: 'MỚI',
      ),
    ];

    final today = DateTime.now();
    final isToday = _isSameDate(date, today);
    final updatedSection = MeetingScheduleSection(
      title: sectionTitle,
      subtitle: isToday ? '${updatedMeetings.length} cuộc họp' : '',
      meetings: updatedMeetings,
    );

    if (targetIndex == -1) {
      sections.add(updatedSection);
    } else {
      sections[targetIndex] = updatedSection;
    }

    sections.refresh();
  }

  String _buildSectionTitle(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    if (_isSameDate(date, today)) {
      return 'HÔM NAY';
    }
    if (_isSameDate(date, tomorrow)) {
      return 'NGÀY MAI, ${_dd(date.day)} THÁNG ${_dd(date.month)}';
    }
    return 'NGÀY ${_dd(date.day)} THÁNG ${_dd(date.month)}, ${date.year}';
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _dd(int n) => n.toString().padLeft(2, '0');
}
