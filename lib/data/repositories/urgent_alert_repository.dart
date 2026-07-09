import '../models/dashboard_models.dart';
import '../models/urgent_alert_models.dart';
import '../services/urgent_alert_service.dart';

class UrgentAlertRepository {
  final UrgentAlertService _service;

  UrgentAlertRepository({UrgentAlertService? service})
    : _service = service ?? UrgentAlertService();

  Future<UrgentAlertBundle> getBundle({
    String key = '',
    int statusId = -100,
  }) async {
    final results = await Future.wait<dynamic>([
      _service.getGroups(page: 1, limit: 100),
      _service.getInformation(
        page: 1,
        limit: 100,
        key: key,
        statusId: statusId,
      ),
      _optional<DashboardNotificationPage>(
        () => _service.getNotifications(page: 1, limit: 10),
        DashboardNotificationPage.empty(),
      ),
    ]);

    return UrgentAlertBundle(
      groups: results[0] as AlertGroupPage,
      information: results[1] as InformationPage,
      notifications: results[2] as DashboardNotificationPage,
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
