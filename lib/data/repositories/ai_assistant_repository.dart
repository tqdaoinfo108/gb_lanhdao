import '../models/ai_assistant_models.dart';
import '../services/ai_assistant_service.dart';

class AiAssistantRepository {
  final AiAssistantService _service;

  AiAssistantRepository({AiAssistantService? service})
    : _service = service ?? AiAssistantService();

  Future<AiHistoryPage> getHistory() => _service.getHistory();

  Future<int> createHistory({required String title, required String content}) =>
      _service.createHistory(title: title, content: content);

  Future<void> updateHistory({
    required int historyChatId,
    required String content,
  }) => _service.updateHistory(historyChatId: historyChatId, content: content);

  Future<AiMonthlyKpiSummary> getMonthlyKpiSummary({
    required int month,
    required int year,
  }) => _service.getMonthlyKpiSummary(month: month, year: year);

  Future<AiMonthlyProcessSummary> getMonthlyProcessSummary({
    required int month,
    required int year,
  }) => _service.getMonthlyProcessSummary(month: month, year: year);

  Future<AiMonthlyResidenceSummary> getMonthlyResidenceSummary({
    required int month,
    required int year,
  }) => _service.getMonthlyResidenceSummary(month: month, year: year);

  Future<AiMonthlyBookingSummary> getMonthlyBookingSummary({
    required int month,
    required int year,
  }) => _service.getMonthlyBookingSummary(month: month, year: year);
}
