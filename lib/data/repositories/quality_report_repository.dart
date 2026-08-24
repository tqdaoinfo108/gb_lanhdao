import '../models/quality_report_models.dart';
import '../services/quality_report_service.dart';

class QualityReportRepository {
  final QualityReportService _service;

  QualityReportRepository({QualityReportService? service})
    : _service = service ?? QualityReportService();

  Future<QualityReportBundle> getBundle({
    required int userId,
    required DateTime monthStart,
    required DateTime monthEnd,
    required int statusId,
  }) async {
    final results = await Future.wait<dynamic>([
      _service.getTemplates(),
      _service.getStaff(),
      _service.getReport(
        userId: userId,
        monthStart: monthStart,
        monthEnd: monthEnd,
        statusId: statusId,
      ),
    ]);
    return QualityReportBundle(
      templates: results[0] as List<QualityTemplate>,
      staff: results[1] as List<QualityStaff>,
      report: results[2] as QualityReportPage,
    );
  }

  Future<QualityYearReportBundle> getYearBundle({
    required int userId,
    required int year,
    required int statusId,
  }) async {
    final results = await Future.wait<dynamic>([
      _service.getStaff(),
      _service.getYearReport(userId: userId, year: year, statusId: statusId),
    ]);
    return QualityYearReportBundle(
      staff: results[0] as List<QualityStaff>,
      report: results[1] as QualityYearReportPage,
    );
  }
}
