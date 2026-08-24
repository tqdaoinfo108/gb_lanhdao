part of '../home_screen.dart';

class _AppItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String search;
  final String? count;
  final AdminSmartView? view;
  final bool isInDevelopment;

  const _AppItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.search,
    this.count,
    this.view,
    this.isInDevelopment = false,
  });
}

class _AppGroup {
  final String title;
  final List<_AppItem> items;
  final SmartTone tone;

  const _AppGroup({
    required this.title,
    required this.items,
    this.tone = SmartTone.accent,
  });
}

const _appGroups = [
  _AppGroup(
    title: 'Điều hành',
    tone: SmartTone.accent,
    items: [
      _AppItem(
        title: 'Dashboard',
        subtitle: 'Công việc, xu hướng và cảnh báo',
        icon: Icons.dashboard_rounded,
        search: 'dashboard lanh dao tong quan',
        view: AdminSmartView.overview,
      ),
      _AppItem(
        title: 'GIS Maps',
        subtitle: 'Bản đồ số trực quan',
        icon: Icons.map_outlined,
        search: 'ban do so dia ban',
        view: AdminSmartView.digitalMap,
      ),
      _AppItem(
        title: 'Hộ dân cư',
        subtitle: 'Quản lý hộ gia đình và nhân khẩu',
        icon: Icons.groups_rounded,
        search: 'dan cu ho gia dinh',
        view: AdminSmartView.residence,
      ),
      _AppItem(
        title: 'Biến động dân cư',
        subtitle: 'Khai sinh và báo tử',
        icon: Icons.person_add_alt_1_rounded,
        search: 'bien dong dan cu khai sinh bao tu',
        view: AdminSmartView.residenceChange,
        isInDevelopment: true,
      ),
      _AppItem(
        title: 'Lịch họp',
        subtitle: 'Lịch, thành phần và nội dung họp',
        icon: Icons.event_note_rounded,
        search: 'hop khong giay to lich hop',
        count: '3',
        view: AdminSmartView.meetingSchedule,
      ),
      _AppItem(
        title: 'Quản lý công việc',
        subtitle: 'Giao việc, tiến độ và kết luận',
        icon: Icons.task_alt_rounded,
        search: 'giao viec ket luan nhiem vu',
        count: '7',
        view: AdminSmartView.tasks,
      ),
    ],
  ),
  _AppGroup(
    title: 'Hỗ trợ & tương tác',
    tone: SmartTone.success,
    items: [
      _AppItem(
        title: 'Báo cáo tổng hợp',
        subtitle: 'Báo cáo tổng hợp và phân tích AI',
        icon: Icons.bar_chart_rounded,
        search: 'reports bao cao tong hop phan tich ai',
        view: AdminSmartView.periodicReport,
      ),
      _AppItem(
        title: 'Báo cáo chất theo kỳ',
        subtitle: 'Thống kê chấm điểm theo kỳ',
        icon: Icons.workspace_premium_outlined,
        search: 'bao cao thong ke chat luong cham diem theo ky',
        view: AdminSmartView.qualityReport,
      ),
      _AppItem(
        title: 'Báo cáo chất theo năm',
        subtitle: 'Tổng hợp xếp loại cả năm',
        icon: Icons.calendar_today_outlined,
        search: 'bao cao thong ke chat luong theo nam xep loai',
        view: AdminSmartView.qualityYearReport,
      ),
      _AppItem(
        title: 'Phản ánh - Kiến nghị',
        subtitle: 'Tiếp nhận, theo dõi và phân loại đơn',
        icon: Icons.gavel_rounded,
        search: 'phan anh kien nghi khieu nai to giac ai',
        view: AdminSmartView.crimeReports,
        isInDevelopment: false,
      ),
      _AppItem(
        title: 'Thông báo',
        subtitle: 'Thông báo theo nhóm người dùng',
        icon: Icons.notifications_active_outlined,
        search: 'thong bao canh bao',
        view: AdminSmartView.urgentAlerts,
      ),
      _AppItem(
        title: 'AI Hỗ trợ',
        subtitle: 'Hỏi đáp nhanh và tổng hợp dữ liệu',
        icon: Icons.auto_awesome_rounded,
        search: 'ai ho tro tro ly bao cao',
        view: AdminSmartView.aiAssistant,
      ),
    ],
  ),
];
