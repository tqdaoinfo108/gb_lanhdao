import '../models/dashboard_models.dart';
import '../models/document_models.dart';
import '../services/document_service.dart';

class DocumentRepository {
  final DocumentService _service;

  DocumentRepository({DocumentService? service})
    : _service = service ?? DocumentService();

  Future<DocumentBundle> getBundle({
    required DateTime monthYear,
    String key = '',
    int statusId = -100,
    int typeDocumentId = -100,
  }) async {
    final results = await Future.wait<dynamic>([
      _service.getDocuments(
        monthYear: monthYear,
        key: key,
        statusId: statusId,
        typeDocumentId: typeDocumentId,
      ),
      _service.getFields(),
      _optional<DashboardNotificationPage>(
        () => _service.getNotifications(),
        DashboardNotificationPage.empty(),
      ),
    ]);

    return DocumentBundle(
      documents: results[0] as DocumentPage,
      fields: results[1] as DocumentFieldPage,
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
