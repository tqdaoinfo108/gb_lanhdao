import '../models/dashboard_models.dart';
import '../services/dashboard_service.dart';

class DashboardRepository {
  final DashboardService _service;

  DashboardRepository({DashboardService? service})
    : _service = service ?? DashboardService();

  Future<DashboardBundle> getDashboard({
    required DateTime dateSearch,
    int typeSearch = 0,
  }) async {
    final date = _formatDate(dateSearch);

    final summary = await _service.getSummary(
      dateSearch: date,
      typeSearch: typeSearch,
    );
    final results = await Future.wait<dynamic>([
      _optional<List<DashboardTrendPoint>>(
        () => _service.getTrends(typeSearch: typeSearch),
        const [],
      ),
      _optional<List<DepartmentWorkload>>(
        () => _service.getDepartmentWorkload(dateSearch: date),
        const [],
      ),
      _optional<List<DashboardKpiItem>>(_service.getPriorityKpis, const []),
      _optional<DashboardUserPage>(
        () => _service.getActiveUsers(page: 1, limit: 5),
        DashboardUserPage.empty(),
      ),
    ]);

    return DashboardBundle(
      summary: summary,
      trends: results[0] as List<DashboardTrendPoint>,
      departments: results[1] as List<DepartmentWorkload>,
      kpis: results[2] as List<DashboardKpiItem>,
      activeUsers: results[3] as DashboardUserPage,
    );
  }

  Future<MeetingHubBundle> getMeetingHub() async {
    final results = await Future.wait<dynamic>([
      _optional<DashboardUserPage>(
        () => _service.getActiveUsersAll(page: 1, limit: 999),
        DashboardUserPage.empty(),
      ),
      _optional<MeetingRoomPage>(
        () => _service.getActiveRooms(page: 1, limit: 100),
        MeetingRoomPage.empty(),
      ),
      _optional<TodayBookingPage>(
        () => _service.getTodayBookings(page: 1, limit: 100),
        TodayBookingPage.empty(),
      ),
    ]);

    return MeetingHubBundle(
      activeUsers: results[0] as DashboardUserPage,
      rooms: results[1] as MeetingRoomPage,
      todayBookings: results[2] as TodayBookingPage,
    );
  }

  Future<PeriodicReportBundle> getPeriodicReport() async {
    final results = await Future.wait<dynamic>([
      _optional<PeriodReportSummary>(
        () => _service.getPeriodSummary(typeSearch: 2),
        PeriodReportSummary.empty(),
      ),
      _optional<List<PeriodTrendPoint>>(
        () => _service.getPeriodTrends(),
        const [],
      ),
      _optional<DashboardNotificationPage>(
        () => _service.getNotifications(page: 1, limit: 10),
        DashboardNotificationPage.empty(),
      ),
    ]);

    return PeriodicReportBundle(
      summary: results[0] as PeriodReportSummary,
      trends: results[1] as List<PeriodTrendPoint>,
      notifications: results[2] as DashboardNotificationPage,
    );
  }

  Future<T> _optional<T>(Future<T> Function() load, T fallback) async {
    try {
      return await load();
    } catch (_) {
      return fallback;
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
