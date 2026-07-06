import '../models/process_models.dart';
import '../services/process_service.dart';

class ProcessRepository {
  final ProcessService _service;

  ProcessRepository({ProcessService? service})
    : _service = service ?? ProcessService();

  Future<ProcessDropdownBundle> getCreateDropdowns() async {
    final results = await Future.wait<dynamic>([
      _optional<List<ProcessUserOption>>(
        () => _service.getActiveUsers(limit: 1000),
        const [],
      ),
      _optional<List<ProcessBookingOption>>(
        () => _service.getBookings(limit: 1000),
        const [],
      ),
      _optional<List<ProcessDocumentOption>>(
        () => _service.getDocuments(limit: 1000),
        const [],
      ),
      _optional<List<ProcessKpiOption>>(
        () => _service.getKpis(page: 1, limit: 1000),
        const [],
      ),
    ]);

    return ProcessDropdownBundle(
      users: results[0] as List<ProcessUserOption>,
      bookings: results[1] as List<ProcessBookingOption>,
      documents: results[2] as List<ProcessDocumentOption>,
      kpis: results[3] as List<ProcessKpiOption>,
    );
  }

  Future<ProcessCreatedItem> create(ProcessCreateRequest request) {
    return _service.create(request);
  }

  Future<T> _optional<T>(Future<T> Function() load, T fallback) async {
    try {
      return await load();
    } catch (_) {
      return fallback;
    }
  }
}
