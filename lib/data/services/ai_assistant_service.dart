import '../../core/network/api_client.dart';
import '../models/ai_assistant_models.dart';

class AiAssistantService extends ApiClient {
  AiAssistantService() {
    onInit();
  }

  Future<AiHistoryPage> getHistory({int limit = 100}) async {
    final response = await get(
      '/history-chat/get-list',
      query: {'limit': '$limit'},
    );
    if (response.isOk && response.body is Map) {
      return AiHistoryPage.fromJson(
        Map<String, dynamic>.from(response.body as Map),
      );
    }
    throw Exception(response.statusText ?? 'Không thể tải lịch sử hội thoại');
  }

  Future<int> createHistory({
    required String title,
    required String content,
  }) async {
    final response = await post('/history-chat/create', {
      'Title': title,
      'Content': content,
    });
    if (response.isOk && response.body is Map) {
      final data = (response.body as Map)['data'];
      if (data is num) return data.toInt();
      return int.tryParse('$data') ?? 0;
    }
    throw Exception(response.statusText ?? 'Không thể tạo cuộc trò chuyện');
  }

  Future<void> updateHistory({
    required int historyChatId,
    required String content,
  }) async {
    final response = await post('/history-chat/update', {
      'HistoryChatID': historyChatId,
      'Content': content,
    });
    if (!response.isOk) {
      throw Exception(response.statusText ?? 'Không thể lưu hội thoại');
    }
  }

  Future<AiMonthlyKpiSummary> getMonthlyKpiSummary({
    required int month,
    required int year,
  }) async {
    final response = await get(
      '/kpi/get-monthly-summary',
      query: {'month': '$month', 'year': '$year'},
    );
    if (response.isOk && response.body is Map) {
      final body = Map<String, dynamic>.from(response.body as Map);
      final data = body['data'];
      if (data is Map) {
        return AiMonthlyKpiSummary.fromJson(Map<String, dynamic>.from(data));
      }
    }
    throw Exception(response.statusText ?? 'Không thể tải tổng hợp KPI');
  }

  Future<AiMonthlyProcessSummary> getMonthlyProcessSummary({
    required int month,
    required int year,
  }) => _getMonthlySummary(
    endpoint: '/process/get-monthly-summary',
    month: month,
    year: year,
    fromJson: AiMonthlyProcessSummary.fromJson,
    error: 'Không thể tải tổng hợp công việc',
  );

  Future<AiMonthlyResidenceSummary> getMonthlyResidenceSummary({
    required int month,
    required int year,
  }) => _getMonthlySummary(
    endpoint: '/house-hold/get-monthly-summary',
    month: month,
    year: year,
    fromJson: AiMonthlyResidenceSummary.fromJson,
    error: 'Không thể tải tổng hợp dân cư',
  );

  Future<AiMonthlyBookingSummary> getMonthlyBookingSummary({
    required int month,
    required int year,
  }) => _getMonthlySummary(
    endpoint: '/booking/get-monthly-summary',
    month: month,
    year: year,
    fromJson: AiMonthlyBookingSummary.fromJson,
    error: 'Không thể tải tổng hợp lịch họp',
  );

  Future<T> _getMonthlySummary<T>({
    required String endpoint,
    required int month,
    required int year,
    required T Function(Map<String, dynamic>) fromJson,
    required String error,
  }) async {
    final response = await get(
      endpoint,
      query: {'month': '$month', 'year': '$year'},
    );
    if (response.isOk && response.body is Map) {
      final data = (response.body as Map)['data'];
      if (data is Map) return fromJson(Map<String, dynamic>.from(data));
    }
    throw Exception(response.statusText ?? error);
  }
}
