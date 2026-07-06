import '../../core/network/api_client.dart';
import '../models/dashboard_models.dart';

class DashboardService extends ApiClient {
  DashboardService() {
    onInit();
  }

  Future<DashboardSummary> getSummary({
    required String dateSearch,
    int typeSearch = 0,
  }) async {
    final body = await _getBody(
      '/dashboard/get-item-part-1',
      query: {'dateSearch': dateSearch, 'typeSearch': typeSearch.toString()},
    );
    return DashboardSummary.fromJson(_dataMap(body));
  }

  Future<List<DashboardTrendPoint>> getTrends({int typeSearch = 0}) async {
    final body = await _getBody(
      '/dashboard/get-item-part-2',
      query: {'typeSearch': typeSearch.toString()},
    );
    return _dataList(
      body,
    ).map((item) => DashboardTrendPoint.fromJson(item)).toList();
  }

  Future<List<DepartmentWorkload>> getDepartmentWorkload({
    required String dateSearch,
  }) async {
    final body = await _getBody(
      '/dashboard/get-item-part-3',
      query: {'dateSearch': dateSearch},
    );
    return _dataList(
      body,
    ).map((item) => DepartmentWorkload.fromJson(item)).toList();
  }

  Future<List<DashboardKpiItem>> getPriorityKpis() async {
    final body = await _getBody('/dashboard/get-item-part-4');
    return _dataList(
      body,
    ).map((item) => DashboardKpiItem.fromJson(item)).toList();
  }

  Future<PeriodReportSummary> getPeriodSummary({int typeSearch = 2}) async {
    final body = await _getBody(
      '/dashboard/get-period',
      query: {'typeSearch': typeSearch.toString()},
    );
    return PeriodReportSummary.fromJson(_dataMap(body));
  }

  Future<List<PeriodTrendPoint>> getPeriodTrends() async {
    final body = await _getBody('/dashboard/get-period-trend');
    return _dataList(body).map((item) => PeriodTrendPoint.fromJson(item)).toList();
  }

  Future<DashboardNotificationPage> getNotifications({
    int page = 1,
    int limit = 10,
  }) async {
    final body = await _getBody(
      '/notifications/get-list-by-user-login',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return DashboardNotificationPage.fromJson(body);
  }

  Future<DashboardUserPage> getActiveUsersAll({
    int page = 1,
    int limit = 999,
  }) async {
    final body = await _getBody(
      '/user/get-list-active',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return DashboardUserPage.fromJson(body);
  }

  Future<MeetingRoomPage> getActiveRooms({
    int page = 1,
    int limit = 100,
  }) async {
    final body = await _getBody(
      '/room-booking/get-list-active',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return MeetingRoomPage.fromJson(body);
  }

  Future<TodayBookingPage> getTodayBookings({
    int page = 1,
    int limit = 100,
  }) async {
    final body = await _getBody(
      '/booking/get-list-by-today',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return TodayBookingPage.fromJson(body);
  }

  Future<DashboardUserPage> getActiveUsers({
    int page = 1,
    int limit = 5,
  }) async {
    final body = await _getBody(
      '/user/get-list-active-dashboard',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return DashboardUserPage.fromJson(body);
  }

  Future<Map<String, dynamic>> _getBody(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    final response = await get(endpoint, query: query);
    if (response.isOk && response.body is Map) {
      return Map<String, dynamic>.from(response.body as Map);
    }
    throw Exception(response.statusText ?? 'Không thể tải dữ liệu dashboard');
  }

  Map<String, dynamic> _dataMap(Map<String, dynamic> body) {
    final data = body['data'];
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const {};
  }

  List<Map<String, dynamic>> _dataList(Map<String, dynamic> body) {
    final data = body['data'];
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
