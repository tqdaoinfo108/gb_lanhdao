import '../models/kpi_models.dart';
import '../services/kpi_service.dart';

class KpiRepository {
  final KpiService _service;

  KpiRepository({KpiService? service}) : _service = service ?? KpiService();

  Future<KpiBundle> getKpiBundle() async {
    final results = await Future.wait<dynamic>([
      _optional<List<KpiMonthlyPoint>>(
        () => _service.getMonthlyChart(months: 6),
        const [],
      ),
      _service.getPrograms(page: 1, limit: 999),
      _optional<List<KpiDepartmentOption>>(
        () => _service.getDepartments(page: 1, limit: 999),
        const [],
      ),
      _optional<List<KpiUserOption>>(
        () => _service.getUsers(page: 1, limit: 999),
        const [],
      ),
      _optional<List<KpiProcessItem>>(
        () => _service.getProcesses(page: 1, limit: 9999),
        const [],
      ),
    ]);

    return KpiBundle(
      chart: results[0] as List<KpiMonthlyPoint>,
      programs: results[1] as List<KpiProgramItem>,
      departments: results[2] as List<KpiDepartmentOption>,
      users: results[3] as List<KpiUserOption>,
      processes: results[4] as List<KpiProcessItem>,
    );
  }

  Future<T> _optional<T>(Future<T> Function() load, T fallback) async {
    try {
      return await load();
    } catch (_) {
      return fallback;
    }
  }
}
