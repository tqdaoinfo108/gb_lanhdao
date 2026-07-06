import '../../core/network/api_client.dart';
import '../models/kpi_models.dart';

class KpiService extends ApiClient {
  KpiService() {
    onInit();
  }

  Future<List<KpiMonthlyPoint>> getMonthlyChart({int months = 6}) async {
    final body = await _getBody(
      '/kpi/get-monthly-chart',
      query: {'months': months.toString()},
    );
    return kpiJsonList(
      body['data'],
    ).map((item) => KpiMonthlyPoint.fromJson(item)).toList();
  }

  Future<List<KpiProgramItem>> getPrograms({
    int page = 1,
    int limit = 999,
  }) async {
    final body = await _getBody(
      '/kpi/get-list',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return kpiJsonList(
      body['data'],
    ).map((item) => KpiProgramItem.fromJson(item)).toList();
  }

  Future<List<KpiDepartmentOption>> getDepartments({
    int page = 1,
    int limit = 999,
  }) async {
    final body = await _getBody(
      '/department/get-list-active',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return kpiJsonList(
      body['data'],
    ).map((item) => KpiDepartmentOption.fromJson(item)).toList();
  }

  Future<List<KpiUserOption>> getUsers({int page = 1, int limit = 999}) async {
    final body = await _getBody(
      '/user/get-list-active',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return kpiJsonList(
      body['data'],
    ).map((item) => KpiUserOption.fromJson(item)).toList();
  }

  Future<List<KpiProcessItem>> getProcesses({
    int page = 1,
    int limit = 9999,
  }) async {
    final body = await _getBody(
      '/process/get-list',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return kpiJsonList(
      body['data'],
    ).map((item) => KpiProcessItem.fromJson(item)).toList();
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
      response.statusText ?? 'Không thể tải dữ liệu chương trình KPI',
    );
  }
}
