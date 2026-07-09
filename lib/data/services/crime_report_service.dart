import '../../core/network/api_client.dart';
import '../models/crime_report_models.dart';

class CrimeReportService extends ApiClient {
  CrimeReportService() {
    onInit();
  }

  /// Danh sách đơn tố giác
  Future<WarningPage> getWarnings({
    int page = 1,
    int limit = 10,
    String key = '',
    int statusId = -100,
    int typeWarningId = 0,
  }) async {
    final body = await _getBody(
      '/warning/get-list',
      query: {
        'page': page.toString(),
        'limit': limit.toString(),
        'key': key,
        'statusID': statusId.toString(),
        'typeWarningID': typeWarningId.toString(),
      },
    );
    return WarningPage.fromJson(body);
  }

  /// Danh sách loại tố giác
  Future<TypeWarningPage> getTypeWarnings({
    int page = 1,
    int limit = 200,
  }) async {
    final body = await _getBody(
      '/type-warning/get-list-active',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return TypeWarningPage.fromJson(body);
  }

  /// Danh sách phòng ban
  Future<CrimeDepartmentPage> getDepartments({
    int page = 1,
    int limit = 200,
  }) async {
    final body = await _getBody(
      '/department/get-list-active',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return CrimeDepartmentPage.fromJson(body);
  }

  Future<WarningAiAnalysis> askAiWarning({
    required String title,
    required String description,
    required String address,
  }) async {
    final response = await post('/warning/ask-ai-warning', {
      'WarningTitle': title,
      'Description': description,
      'Address': address,
    });
    if (response.isOk && response.body is Map) {
      return WarningAiAnalysis.fromJson(
        Map<String, dynamic>.from(response.body as Map),
      );
    }
    throw Exception(response.statusText ?? 'Không thể phân tích AI tố giác');
  }

  Future<WarningItem> createWarning(WarningCreateRequest request) async {
    final response = await post('/warning/create-warning', request.toJson());
    if (response.isOk && response.body is Map) {
      final body = Map<String, dynamic>.from(response.body as Map);
      final data = body['data'] is Map
          ? Map<String, dynamic>.from(body['data'] as Map)
          : body;
      return WarningItem.fromJson(data);
    }
    throw Exception(response.statusText ?? 'Không thể nộp đơn tố giác');
  }

  Future<Map<String, dynamic>> _getBody(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    final response = await get(endpoint, query: query);
    if (response.isOk && response.body is Map) {
      return Map<String, dynamic>.from(response.body as Map);
    }
    throw Exception(response.statusText ?? 'Không thể tải dữ liệu tố giác');
  }
}
