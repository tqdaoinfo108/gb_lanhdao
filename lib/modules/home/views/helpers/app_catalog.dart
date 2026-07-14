part of '../home_screen.dart';

class _AppItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String search;
  final String? count;
  final AdminSmartView? view;

  const _AppItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.search,
    this.count,
    this.view,
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
    title: 'Tổng quan',
    tone: SmartTone.accent,
    items: [
      _AppItem(
        title: 'Dashboard Lãnh đạo',
        subtitle: 'KPI và cảnh báo điều hành',
        icon: Icons.dashboard_rounded,
        search: 'dashboard lanh dao tong quan',
        view: AdminSmartView.overview,
      ),
      _AppItem(
        title: 'Bản đồ số',
        subtitle: 'Điểm nóng theo địa bàn',
        icon: Icons.map_outlined,
        search: 'ban do so dia ban',
        view: AdminSmartView.digitalMap,
      ),
      _AppItem(
        title: 'Tố giác tội phạm',
        subtitle: 'Tiếp nhận và xử lý đơn',
        icon: Icons.gavel_rounded,
        search: 'to giac toi pham khieu nai',
        view: AdminSmartView.crimeReports,
      ),
      _AppItem(
        title: 'AI Hỗ trợ',
        subtitle: 'Tìm kiếm và gợi ý xử lý',
        icon: Icons.auto_awesome_rounded,
        search: 'ai ho tro tro ly',
        view: AdminSmartView.aiAssistant,
      ),
      _AppItem(
        title: 'Dân cư & Hộ gia đình',
        subtitle: 'Biến động cư trú',
        icon: Icons.groups_rounded,
        search: 'dan cu ho gia dinh',
        view: AdminSmartView.residence,
      ),
      _AppItem(
        title: 'Báo cáo định kỳ',
        subtitle: 'Tổng hợp theo kỳ',
        icon: Icons.bar_chart_rounded,
        search: 'bao cao dinh ky',
        view: AdminSmartView.periodicReport,
      ),
    ],
  ),
  _AppGroup(
    title: 'Nghiệp vụ',
    tone: SmartTone.success,
    items: [
      _AppItem(
        title: 'Họp không giấy tờ',
        subtitle: 'Lịch, tài liệu, biên bản',
        icon: Icons.event_note_rounded,
        search: 'hop khong giay to lich hop',
        count: '3',
        view: AdminSmartView.meetingSchedule,
      ),
      _AppItem(
        title: 'Chương trình & KPI',
        subtitle: 'Mục tiêu và chỉ tiêu',
        icon: Icons.query_stats_rounded,
        search: 'chuong trinh kpi',
        view: AdminSmartView.kpiPrograms,
      ),
      _AppItem(
        title: 'Giao việc & Kết luận',
        subtitle: 'Phân công, tiến độ, ký nhận',
        icon: Icons.task_alt_rounded,
        search: 'giao viec ket luan nhiem vu',
        count: '7',
        view: AdminSmartView.tasks,
      ),
      _AppItem(
        title: 'Văn bản / Công văn',
        subtitle: 'Luân chuyển xử lý',
        icon: Icons.description_outlined,
        search: 'van ban cong van',
        count: '4',
        view: AdminSmartView.documents,
      ),
      _AppItem(
        title: 'Lịch công tác chung',
        subtitle: 'Điều phối lịch đơn vị',
        icon: Icons.calendar_month_rounded,
        search: 'lich cong tac chung',
        view: AdminSmartView.workCalendar,
      ),
      _AppItem(
        title: 'Thông báo khẩn',
        subtitle: 'Cảnh báo cần xử lý',
        icon: Icons.warning_amber_rounded,
        search: 'thong bao khan',
        view: AdminSmartView.urgentAlerts,
      ),
    ],
  ),
  _AppGroup(
    title: 'Địa bàn',
    tone: SmartTone.warning,
    items: [
      _AppItem(
        title: 'Địa điểm số',
        subtitle: 'Vị trí và điểm dữ liệu',
        icon: Icons.place_outlined,
        search: 'dia diem so',
        view: AdminSmartView.offices,
      ),
      _AppItem(
        title: 'Cơ quan / Sở ban ngành',
        subtitle: 'Danh bạ đơn vị phối hợp',
        icon: Icons.account_tree_outlined,
        search: 'co quan so ban nganh',
        view: AdminSmartView.agencies,
      ),
    ],
  ),
];
