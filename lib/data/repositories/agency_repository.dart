import '../models/agency_models.dart';
import '../models/dashboard_models.dart';
import '../services/agency_service.dart';

class AgencyRepository {
  final AgencyService _service;

  AgencyRepository({AgencyService? service})
    : _service = service ?? AgencyService();

  Future<AgencyBundle> getAgencyBundle({
    int statusId = -100,
    int page = 1,
    int limit = 5,
    String key = '',
  }) async {
    final results = await Future.wait<dynamic>([
      _service.getList(statusId: statusId, page: page, limit: limit, key: key),
      _optional<DashboardNotificationPage>(
        () => _service.getNotifications(page: 1, limit: 10),
        DashboardNotificationPage.empty(),
      ),
    ]);

    return AgencyBundle(
      agencyPage: results[0] as AgencyPage,
      notifications: results[1] as DashboardNotificationPage,
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
