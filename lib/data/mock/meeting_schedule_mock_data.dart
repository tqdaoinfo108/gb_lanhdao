import '../models/meeting_schedule_models.dart';

/// Mock data cho màn hình Lịch họp.
class MeetingScheduleMockData {
  MeetingScheduleMockData._();

  static const String headerTitle = 'Lịch họp sắp tới';
  static const String headerDate = 'Thứ Hai, 29 Tháng 03, 2026';
  static const List<String> locationOptions = [
    'Phòng IT - Tầng 3',
    'Phòng IT - Tầng 5',
    'Phòng họp A',
    'Phòng họp B',
    'Zoom Meeting',
    'Google Meet',
  ];

  static const List<MeetingScheduleSection> sections = [
    MeetingScheduleSection(
      title: 'HÔM NAY',
      subtitle: '2 cuộc họp',
      meetings: [
        MeetingScheduleItem(
          time: '14:00',
          title: 'Họp giao ban tuần UBND Phường',
          location: 'Phòng họp A',
          duration: '90 phút',
          organizer: 'Tổ chức: Nguyễn Văn Minh',
          attendeeSummary: '12',
          statusLabel: 'SẮP DIỄN RA',
          isHighlighted: true,
        ),
        MeetingScheduleItem(
          time: '16:30',
          title: 'Báo cáo KPI Quý 1 – Khối Tư Pháp',
          location: 'Zoom Meeting',
          duration: '',
          platform: 'Zoom Meeting',
          attendeeSummary: '8',
          statusLabel: 'TIẾP THEO',
        ),
      ],
    ),
    MeetingScheduleSection(
      title: 'NGÀY MAI, 30 THÁNG 03',
      subtitle: '',
      meetings: [
        MeetingScheduleItem(
          time: '08:30',
          title: 'Họp xét duyệt hồ sơ đất đai',
          location: 'Phòng họp B',
          duration: '120 phút',
        ),
      ],
    ),
  ];
}
