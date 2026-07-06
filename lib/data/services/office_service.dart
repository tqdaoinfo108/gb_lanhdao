import '../../core/network/api_client.dart';
import '../models/dashboard_models.dart';
import '../models/office_models.dart';

class OfficeService extends ApiClient {
  OfficeService() {
    onInit();
  }

  Future<OfficePage> getList({
    String key = '',
    int typeOfficeId = 0,
    int statusId = -100,
    int page = 1,
    int limit = 10,
  }) async {
    final body = await _getBody(
      '/office/get-list',
      query: {
        'key': key,
        'typeOfficeID': typeOfficeId.toString(),
        'statusID': statusId.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    return OfficePage.fromJson(body);
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
    throw Exception(response.statusText ?? 'Không thể tải dữ liệu địa điểm');
  }
}
