import '../models/crime_report_models.dart';
import '../services/crime_report_service.dart';

class CrimeReportRepository {
  final CrimeReportService _service;

  CrimeReportRepository({CrimeReportService? service})
    : _service = service ?? CrimeReportService();

  Future<CrimeReportBundle> getBundle({
    String key = '',
    int statusId = -100,
    int typeWarningId = 0,
  }) async {
    final results = await Future.wait<dynamic>([
      _service.getWarnings(
        page: 1,
        limit: 100,
        key: key,
        statusId: statusId,
        typeWarningId: typeWarningId,
      ),
      _optional<TypeWarningPage>(
        () => _service.getTypeWarnings(page: 1, limit: 200),
        TypeWarningPage.empty(),
      ),
      _optional<CrimeDepartmentPage>(
        () => _service.getDepartments(page: 1, limit: 200),
        CrimeDepartmentPage.empty(),
      ),
    ]);

    return CrimeReportBundle(
      warnings: results[0] as WarningPage,
      types: results[1] as TypeWarningPage,
      departments: results[2] as CrimeDepartmentPage,
    );
  }

  Future<T> _optional<T>(Future<T> Function() load, T fallback) async {
    try {
      return await load();
    } catch (_) {
      return fallback;
    }
  }

  Future<WarningAiAnalysis> askAiWarning({
    required String title,
    required String description,
    required String address,
  }) {
    return _service.askAiWarning(
      title: title,
      description: description,
      address: address,
    );
  }

  Future<WarningItem> createWarning(WarningCreateRequest request) {
    return _service.createWarning(request);
  }
}
