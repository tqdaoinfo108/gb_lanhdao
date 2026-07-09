import '../../core/network/api_client.dart';
import '../models/dashboard_models.dart';
import '../models/urgent_alert_models.dart';

class UrgentAlertService extends ApiClient {
  UrgentAlertService() {
    onInit();
  }

  Future<AlertGroupPage> getGroups({int page = 1, int limit = 100}) async {
    final body = await _getBody(
      '/group/get-list',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return AlertGroupPage.fromJson(body);
  }

  Future<InformationPage> getInformation({
    int page = 1,
    int limit = 100,
    String key = '',
    int statusId = -100,
  }) async {
    final body = await _getBody(
      '/information/get-list',
      query: {
        'page': page.toString(),
        'limit': limit.toString(),
        'key': key,
        'statusID': statusId.toString(),
      },
    );
    return InformationPage.fromJson(body);
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

  Future<Map<String, dynamic>> _getBody(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    final response = await get(endpoint, query: query);
    if (response.isOk && response.body is Map) {
      return Map<String, dynamic>.from(response.body as Map);
    }
    throw Exception(response.statusText ?? 'Không thể tải thông báo khẩn');
  }
}
