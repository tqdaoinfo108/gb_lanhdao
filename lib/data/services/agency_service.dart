import '../../core/network/api_client.dart';
import '../models/agency_models.dart';
import '../models/dashboard_models.dart';

class AgencyService extends ApiClient {
  AgencyService() {
    onInit();
  }

  Future<AgencyPage> getList({
    int statusId = -100,
    int page = 1,
    int limit = 5,
    String key = '',
  }) async {
    final body = await _getBody(
      '/agency/get-list',
      query: {
        'statusID': statusId.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
        'key': key,
      },
    );
    return AgencyPage.fromJson(body);
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
    throw Exception(
      response.statusText ?? 'Không thể tải dữ liệu sở ban ngành',
    );
  }
}
