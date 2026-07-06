import '../models/dashboard_models.dart';
import '../models/office_models.dart';
import '../services/office_service.dart';

class OfficeRepository {
  final OfficeService _service;

  OfficeRepository({OfficeService? service})
    : _service = service ?? OfficeService();

  Future<OfficeBundle> getOfficeBundle({
    String key = '',
    int typeOfficeId = 0,
    int statusId = -100,
    int page = 1,
    int limit = 10,
  }) async {
    final results = await Future.wait<dynamic>([
      _service.getList(
        key: key,
        typeOfficeId: typeOfficeId,
        statusId: statusId,
        page: page,
        limit: limit,
      ),
      _optional<DashboardNotificationPage>(
        () => _service.getNotifications(page: 1, limit: 10),
        DashboardNotificationPage.empty(),
      ),
    ]);

    return OfficeBundle(
      officePage: results[0] as OfficePage,
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
