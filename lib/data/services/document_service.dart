import '../../core/network/api_client.dart';
import '../models/dashboard_models.dart';
import '../models/document_models.dart';

class DocumentService extends ApiClient {
  DocumentService() {
    onInit();
  }

  Future<DocumentFieldPage> getFields({int limit = 1000}) async {
    final body = await _getBody(
      '/fields/get-list-active',
      query: {'limit': limit.toString()},
    );
    return DocumentFieldPage.fromJson(body);
  }

  Future<DocumentPage> getDocuments({
    int page = 1,
    int limit = 20,
    required DateTime monthYear,
    String key = '',
    int statusId = -100,
    int typeDocumentId = -100,
  }) async {
    final body = await _getBody(
      '/document/get-list',
      query: {
        'page': page.toString(),
        'limit': limit.toString(),
        'monthYear': _monthParam(monthYear),
        'key': key,
        'statusID': statusId.toString(),
        'typeDocumentID': typeDocumentId.toString(),
      },
    );
    return DocumentPage.fromJson(body);
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
    throw Exception(response.statusText ?? 'Không thể tải dữ liệu văn bản');
  }

  String _monthParam(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    return '${value.year}-$month-01';
  }
}
