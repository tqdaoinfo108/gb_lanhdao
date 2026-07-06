import '../../core/network/api_client.dart';
import '../models/process_models.dart';

class ProcessService extends ApiClient {
  ProcessService() {
    onInit();
  }

  Future<List<ProcessUserOption>> getActiveUsers({int limit = 1000}) async {
    final body = await _getBody(
      '/user/get-list-active',
      query: {'limit': limit.toString()},
    );
    return _dataList(
      body,
    ).map((item) => ProcessUserOption.fromJson(item)).toList();
  }

  Future<List<ProcessBookingOption>> getBookings({int limit = 1000}) async {
    final body = await _getBody(
      '/booking/get-list',
      query: {'limit': limit.toString()},
    );
    return _dataList(
      body,
    ).map((item) => ProcessBookingOption.fromJson(item)).toList();
  }

  Future<List<ProcessDocumentOption>> getDocuments({int limit = 1000}) async {
    final body = await _getBody(
      '/document/get-list',
      query: {'limit': limit.toString()},
    );
    return _dataList(
      body,
    ).map((item) => ProcessDocumentOption.fromJson(item)).toList();
  }

  Future<List<ProcessKpiOption>> getKpis({
    int page = 1,
    int limit = 1000,
  }) async {
    final body = await _getBody(
      '/kpi/get-list',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return _dataList(
      body,
    ).map((item) => ProcessKpiOption.fromJson(item)).toList();
  }

  Future<ProcessCreatedItem> create(ProcessCreateRequest request) async {
    final response = await post('/process/create', request.toJson());
    if (response.isOk && response.body is Map) {
      final body = Map<String, dynamic>.from(response.body as Map);
      final data = body['data'];
      if (data is Map) {
        return ProcessCreatedItem.fromJson(Map<String, dynamic>.from(data));
      }
    }
    throw Exception(response.statusText ?? 'Không thể tạo giao việc');
  }

  Future<Map<String, dynamic>> _getBody(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    final response = await get(endpoint, query: query);
    if (response.isOk && response.body is Map) {
      return Map<String, dynamic>.from(response.body as Map);
    }
    throw Exception(response.statusText ?? 'Không thể tải dữ liệu giao việc');
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
