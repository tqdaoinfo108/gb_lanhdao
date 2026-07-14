import '../../widgets/admin_smart_ui.dart';
import 'dashboard_models.dart';

class DocumentFieldItem {
  final int fieldId;
  final String fieldName;
  final int statusId;
  final String description;
  final String userCreated;
  final String userUpdated;
  final DateTime? dateCreated;
  final DateTime? dateUpdated;

  const DocumentFieldItem({
    required this.fieldId,
    required this.fieldName,
    required this.statusId,
    required this.description,
    required this.userCreated,
    required this.userUpdated,
    required this.dateCreated,
    required this.dateUpdated,
  });

  factory DocumentFieldItem.fromJson(Map<String, dynamic> json) {
    return DocumentFieldItem(
      fieldId: _asInt(json['FieldID']),
      fieldName: json['FieldName'] as String? ?? '',
      statusId: _asInt(json['StatusID'] ?? json['StautusID']),
      description: json['Description'] as String? ?? '',
      userCreated: json['UserCreated'] as String? ?? '',
      userUpdated: json['UserUpdated'] as String? ?? '',
      dateCreated: _asDate(json['DateCreated']),
      dateUpdated: _asDate(json['DateUpdated']),
    );
  }
}

class DocumentFieldPage {
  final int totals;
  final List<DocumentFieldItem> fields;

  const DocumentFieldPage({required this.totals, required this.fields});

  factory DocumentFieldPage.empty() {
    return const DocumentFieldPage(totals: 0, fields: []);
  }

  factory DocumentFieldPage.fromJson(Map<String, dynamic> json) {
    return DocumentFieldPage(
      totals: _asInt(json['totals']),
      fields: _asList(json['data']).map(DocumentFieldItem.fromJson).toList(),
    );
  }
}

class DocumentItem {
  final int documentId;
  final int typeDocumentId;
  final String documentCode;
  final String documentTitle;
  final int agencyIdFrom;
  final String agencyNameFrom;
  final int agencyIdTo;
  final String agencyNameTo;
  final DateTime? dateIssuance;
  final DateTime? dateExpired;
  final int levelId;
  final int statusId;
  final String statusName;
  final int fieldId;
  final int userIdProcess;
  final int departmentId;
  final String fullNameProcess;
  final int numberPage;
  final bool isSignature;
  final String description;
  final String userCreated;
  final String userUpdated;
  final DateTime? dateCreated;
  final DateTime? dateUpdated;

  const DocumentItem({
    required this.documentId,
    required this.typeDocumentId,
    required this.documentCode,
    required this.documentTitle,
    required this.agencyIdFrom,
    required this.agencyNameFrom,
    required this.agencyIdTo,
    required this.agencyNameTo,
    required this.dateIssuance,
    required this.dateExpired,
    required this.levelId,
    required this.statusId,
    required this.statusName,
    required this.fieldId,
    required this.userIdProcess,
    required this.departmentId,
    required this.fullNameProcess,
    required this.numberPage,
    required this.isSignature,
    required this.description,
    required this.userCreated,
    required this.userUpdated,
    required this.dateCreated,
    required this.dateUpdated,
  });

  bool get isIncoming => typeDocumentId == 1;

  bool get isOutgoing => typeDocumentId == 2;

  bool get isUrgent => levelId >= 2;

  bool get isExpired {
    final expired = dateExpired;
    if (expired == null) return false;
    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day);
    return expired.isBefore(day) && !isSignature && statusId == 1;
  }

  String get typeLabel => isOutgoing ? 'Đi' : 'Đến';

  String get levelLabel => isUrgent ? 'Khẩn' : 'Thường';

  String get displayStatus {
    if (isSignature) return 'Đã ký số';
    if (statusId == 1) return 'Chờ xử lý';
    if (statusId == 3 || statusId == 4) return 'Hoàn thành';
    if (statusName.trim().isNotEmpty) return statusName.trim();
    return 'Chưa rõ';
  }

  SmartTone get statusTone {
    if (isSignature) return SmartTone.accent;
    if (isExpired) return SmartTone.danger;
    if (statusId == 1) return SmartTone.warning;
    if (statusId == 3 || statusId == 4) return SmartTone.success;
    return SmartTone.neutral;
  }

  SmartTone get typeTone => isOutgoing ? SmartTone.success : SmartTone.accent;

  factory DocumentItem.fromJson(Map<String, dynamic> json) {
    return DocumentItem(
      documentId: _asInt(json['DocumentID']),
      typeDocumentId: _asInt(json['TypeDocumentID']),
      documentCode: json['DocumentCode'] as String? ?? '',
      documentTitle: json['DocumentTitle'] as String? ?? '',
      agencyIdFrom: _asInt(json['AgencyIDFrom']),
      agencyNameFrom: json['AgencyNameFrom'] as String? ?? '',
      agencyIdTo: _asInt(json['AgencyIDTo']),
      agencyNameTo: json['AgencyNameTo'] as String? ?? '',
      dateIssuance: _asDate(json['DateIssuance']),
      dateExpired: _asDate(json['DateExpired']),
      levelId: _asInt(json['LevelID']),
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
      fieldId: _asInt(json['FieldID']),
      userIdProcess: _asInt(json['UserIDProcess']),
      departmentId: _asInt(json['DepartmentID']),
      fullNameProcess: json['FullNameProcess'] as String? ?? '',
      numberPage: _asInt(json['NumberPage']),
      isSignature: json['IsSignature'] as bool? ?? false,
      description: json['Description'] as String? ?? '',
      userCreated: json['UserCreated'] as String? ?? '',
      userUpdated: json['UserUpdated'] as String? ?? '',
      dateCreated: _asDate(json['DateCreated']),
      dateUpdated: _asDate(json['DateUpdated']),
    );
  }
}

class DocumentPage {
  final int totals;
  final int totalByMonth;
  final int totalReceived;
  final int totalSent;
  final int totalNeedView;
  final List<DocumentItem> documents;

  const DocumentPage({
    required this.totals,
    required this.totalByMonth,
    required this.totalReceived,
    required this.totalSent,
    required this.totalNeedView,
    required this.documents,
  });

  int get urgentCount => documents.where((item) => item.isUrgent).length;

  factory DocumentPage.empty() {
    return const DocumentPage(
      totals: 0,
      totalByMonth: 0,
      totalReceived: 0,
      totalSent: 0,
      totalNeedView: 0,
      documents: [],
    );
  }

  factory DocumentPage.fromJson(Map<String, dynamic> json) {
    return DocumentPage(
      totals: _asInt(json['totals']),
      totalByMonth: _asInt(json['totalByMonth']),
      totalReceived: _asInt(json['totalReceived']),
      totalSent: _asInt(json['totalSent']),
      totalNeedView: _asInt(json['totalNeedView']),
      documents: _asList(json['data']).map(DocumentItem.fromJson).toList(),
    );
  }
}

class DocumentBundle {
  final DocumentPage documents;
  final DocumentFieldPage fields;
  final DashboardNotificationPage notifications;

  const DocumentBundle({
    required this.documents,
    required this.fields,
    required this.notifications,
  });

  String fieldName(int fieldId) {
    final matches = fields.fields.where((field) => field.fieldId == fieldId);
    return matches.isEmpty ? 'Chưa phân lĩnh vực' : matches.first.fieldName;
  }

  factory DocumentBundle.empty() {
    return DocumentBundle(
      documents: DocumentPage.empty(),
      fields: DocumentFieldPage.empty(),
      notifications: DashboardNotificationPage.empty(),
    );
  }
}

int _asInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

DateTime? _asDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}
