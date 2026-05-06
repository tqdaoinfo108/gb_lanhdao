import '../models/dashboard_models.dart';

/// Mock data cho màn hình Home.
/// Khi implement API thực, thay thế bằng dữ liệu từ Repository.
class HomeMockData {
  HomeMockData._();

  // -------------------------------------------------------------------------
  // User
  // -------------------------------------------------------------------------
  static const String userName = 'Nguyễn Văn Minh';
  static const String userAvatar = ''; // URL avatar, để trống dùng placeholder

  // -------------------------------------------------------------------------
  // KPI Summary (2x2 grid)
  // -------------------------------------------------------------------------
  static const List<KpiSummary> kpiSummaries = [
    KpiSummary(
      title: 'TIẾN ĐỘ DỰ ÁN',
      value: '73.4',
      unit: '%',
      description: '11/15 chương trình đúng',
      trend: '+0.2% so với tháng trước',
      isTrendPositive: true,
      iconType: KpiIconType.project,
    ),
    KpiSummary(
      title: 'NHÂN SỰ',
      value: '94.1',
      unit: '%',
      description: '48/51 cán bộ có mặt hôm nay',
      trend: '1.2% so với tháng trước',
      isTrendPositive: false,
      iconType: KpiIconType.staff,
    ),
    KpiSummary(
      title: 'CUỘC HỌP',
      value: '6',
      unit: ' cuộc',
      description: '2 cuộc họp quan trọng',
      trend: '+40% so với tháng trước',
      isTrendPositive: true,
      iconType: KpiIconType.meeting,
    ),
    KpiSummary(
      title: 'DÂN CƯ',
      value: '23',
      unit: ' hồ sơ',
      description: '15 nhập khẩu, 8 xuất khẩu',
      trend: '-5 so với tháng trước',
      isTrendPositive: false,
      iconType: KpiIconType.resident,
    ),
  ];

  // -------------------------------------------------------------------------
  // Alert
  // -------------------------------------------------------------------------
  static const AlertInfo alert = AlertInfo(
    count: 7,
    label: '7 công việc quá hạn',
    description: 'Cần phản công lại trước 17:00 hôm nay',
  );

  // -------------------------------------------------------------------------
  // Weekly Chart Data
  // -------------------------------------------------------------------------
  static const List<ChartDataPoint> weeklyChart = [
    ChartDataPoint(label: 'T3', value: 45),
    ChartDataPoint(label: 'T4', value: 52),
    ChartDataPoint(label: 'T5', value: 48),
    ChartDataPoint(label: 'T6', value: 60),
    ChartDataPoint(label: 'T7', value: 72),
    ChartDataPoint(label: 'CN', value: 68),
  ];

  // -------------------------------------------------------------------------
  // AI Insight
  // -------------------------------------------------------------------------
  static const AiInsight aiInsight = AiInsight(
    content:
        'Dựa trên dữ liệu nhân sự hiện tại, bạn nên ưu tiên phê duyệt 3 đề xuất nghỉ phép đang chờ để tránh xung đột lịch trực tuần tới.',
    actionLabel: 'Xử lý ngay',
  );

  // -------------------------------------------------------------------------
  // Meetings
  // -------------------------------------------------------------------------
  static const List<MeetingItem> meetings = [
    MeetingItem(
      time: '08:30',
      title: 'Họp giao ban đầu tuần - UBND Phường 5',
      location: 'Phòng họp số 1, Tầng 2',
    ),
    MeetingItem(
      time: '10:00',
      title: 'Phê duyệt phương án cải cách hành chính Q2',
      location: 'Văn phòng Chủ tịch',
    ),
    MeetingItem(
      time: '14:00',
      title: 'Tiếp công dân định kỳ tháng 3/2026',
      location: 'Sảnh tiếp dân',
      tag: 'Sắp tới',
    ),
    MeetingItem(
      time: '16:30',
      title: 'Họp trực tuyến với Ban Chỉ đạo Quận 8',
      location: 'Phòng họp trực tuyến',
    ),
  ];

  static const int totalMeetings = 8;
}
