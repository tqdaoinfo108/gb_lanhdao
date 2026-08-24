import '../../core/network/api_client.dart';
import '../models/quality_report_models.dart';

class QualityReportService extends ApiClient {
  QualityReportService() {
    onInit();
  }

  Future<List<QualityTemplate>> getTemplates() async {
    final body = await _getBody(
      '/template/get-list-active',
      query: {'page': '1', 'limit': '100'},
    );
    return _dataList(body).map(QualityTemplate.fromJson).toList();
  }

  Future<List<QualityStaff>> getStaff({int departmentId = 1}) async {
    final body = await _getBody(
      '/user/get-by-department',
      query: {'departmentID': '$departmentId'},
    );
    return _dataList(body).map(QualityStaff.fromJson).toList();
  }

  Future<QualityReportPage> getReport({
    required int userId,
    required DateTime monthStart,
    required DateTime monthEnd,
    required int statusId,
  }) async {
    final body = await _getBody(
      '/report-user-scoring/bao-cao',
      query: {
        'userID': '$userId',
        'monthStart': monthStart.toIso8601String(),
        'monthEnd': monthEnd.toIso8601String(),
        'statusID': '$statusId',
        'page': '1',
        'limit': '100',
      },
    );
    return QualityReportPage.fromJson(body);
  }

  Future<QualityYearReportPage> getYearReport({
    required int userId,
    required int year,
    required int statusId,
  }) async {
    final body = await _getBody(
      '/report-year/bao-cao',
      query: {
        'userID': '$userId',
        'year': '$year',
        'statusID': '$statusId',
        'page': '1',
        'limit': '100',
      },
    );
    return QualityYearReportPage.fromJson(body);
  }

  Future<Map<String, dynamic>> _getBody(
    String endpoint, {
    Map<String, String>? query,
  }) async {
    final response = await get(endpoint, query: query);
    if (response.isOk && response.body is Map) {
      return Map<String, dynamic>.from(response.body as Map);
    }
    throw Exception(response.statusText ?? 'Không thể tải báo cáo chất lượng');
  }

  List<Map<String, dynamic>> _dataList(Map<String, dynamic> body) {
    final data = body['data'];
    return data is List
        ? data
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
        : const [];
  }
}
