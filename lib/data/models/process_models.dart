class ProcessDropdownBundle {
  final List<ProcessUserOption> users;
  final List<ProcessBookingOption> bookings;
  final List<ProcessDocumentOption> documents;
  final List<ProcessKpiOption> kpis;

  const ProcessDropdownBundle({
    required this.users,
    required this.bookings,
    required this.documents,
    required this.kpis,
  });

  factory ProcessDropdownBundle.empty() {
    return const ProcessDropdownBundle(
      users: [],
      bookings: [],
      documents: [],
      kpis: [],
    );
  }

  bool get isEmpty =>
      users.isEmpty && bookings.isEmpty && documents.isEmpty && kpis.isEmpty;
}

class ProcessUserOption {
  final int userId;
  final String fullName;
  final String userName;
  final String departmentName;
  final String positionName;
  final String phone;

  const ProcessUserOption({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.departmentName,
    required this.positionName,
    required this.phone,
  });

  String get displayName => fullName.trim().isNotEmpty ? fullName : userName;

  factory ProcessUserOption.fromJson(Map<String, dynamic> json) {
    return ProcessUserOption(
      userId: _asInt(json['UserID']),
      fullName: json['FullName'] as String? ?? '',
      userName: json['UserName'] as String? ?? '',
      departmentName: json['DepartmentName'] as String? ?? 'Chưa xác định',
      positionName: json['PositionName'] as String? ?? '',
      phone: json['Phone'] as String? ?? '',
    );
  }
}

class ProcessBookingOption {
  final int bookingId;
  final String title;
  final DateTime? dateStart;
  final String typeBookingName;
  final List<ProcessConclusionOption> conclusions;

  const ProcessBookingOption({
    required this.bookingId,
    required this.title,
    required this.dateStart,
    required this.typeBookingName,
    required this.conclusions,
  });

  String get codeReference => 'Booking $bookingId';

  factory ProcessBookingOption.fromJson(Map<String, dynamic> json) {
    return ProcessBookingOption(
      bookingId: _asInt(json['BookingID']),
      title: json['BookingTitle'] as String? ?? 'Cuộc họp chưa đặt tên',
      dateStart: _asDate(json['DateStart']),
      typeBookingName: json['TypeBookingName'] as String? ?? '',
      conclusions: _asList(
        json['lstConclusion'],
      ).map((item) => ProcessConclusionOption.fromJson(item)).toList(),
    );
  }
}

class ProcessConclusionOption {
  final int conclusionId;
  final String code;
  final String title;

  const ProcessConclusionOption({
    required this.conclusionId,
    required this.code,
    required this.title,
  });

  String get codeReference =>
      code.trim().isNotEmpty ? code.trim() : 'Conclusion $conclusionId';

  factory ProcessConclusionOption.fromJson(Map<String, dynamic> json) {
    return ProcessConclusionOption(
      conclusionId: _asInt(json['ConclusionID'] ?? json['ID']),
      code:
          json['ConclusionCode'] as String? ??
          json['CodeReference'] as String? ??
          json['Code'] as String? ??
          '',
      title:
          json['ConclusionTitle'] as String? ??
          json['Title'] as String? ??
          json['ConclusionName'] as String? ??
          'Kết luận',
    );
  }
}

class ProcessDocumentOption {
  final int documentId;
  final String title;
  final String code;

  const ProcessDocumentOption({
    required this.documentId,
    required this.title,
    required this.code,
  });

  String get codeReference =>
      code.trim().isNotEmpty ? code.trim() : 'Document $documentId';

  factory ProcessDocumentOption.fromJson(Map<String, dynamic> json) {
    return ProcessDocumentOption(
      documentId: _asInt(json['DocumentID'] ?? json['ID']),
      title:
          json['DocumentTitle'] as String? ??
          json['Title'] as String? ??
          json['DocumentName'] as String? ??
          'Văn bản',
      code:
          json['DocumentCode'] as String? ??
          json['CodeReference'] as String? ??
          json['Code'] as String? ??
          '',
    );
  }
}

class ProcessKpiOption {
  final int kpiId;
  final String kpiName;
  final String departmentName;
  final String fullName;
  final double progress;

  const ProcessKpiOption({
    required this.kpiId,
    required this.kpiName,
    required this.departmentName,
    required this.fullName,
    required this.progress,
  });

  String get codeReference => 'KPI $kpiId';

  factory ProcessKpiOption.fromJson(Map<String, dynamic> json) {
    return ProcessKpiOption(
      kpiId: _asInt(json['KPIID']),
      kpiName: json['KPIName'] as String? ?? 'KPI chưa đặt tên',
      departmentName: json['DepartmentName'] as String? ?? 'Chưa xác định',
      fullName: json['FullName'] as String? ?? '',
      progress: _asDouble(json['Progress'] ?? json['Reality']),
    );
  }
}

class ProcessLevelOption {
  final int levelId;
  final String name;

  const ProcessLevelOption({required this.levelId, required this.name});

  static const all = [
    ProcessLevelOption(levelId: 1, name: 'Thấp'),
    ProcessLevelOption(levelId: 2, name: 'Trung bình'),
    ProcessLevelOption(levelId: 3, name: 'Cao'),
  ];
}

class ProcessSourceTypeOption {
  final int typeSourceId;
  final String name;

  const ProcessSourceTypeOption({
    required this.typeSourceId,
    required this.name,
  });

  static const conclusion = ProcessSourceTypeOption(
    typeSourceId: 1,
    name: 'Kết luận',
  );
  static const document = ProcessSourceTypeOption(
    typeSourceId: 2,
    name: 'Văn bản',
  );
  static const kpi = ProcessSourceTypeOption(typeSourceId: 3, name: 'KPI');

  static const all = [conclusion, document, kpi];
}

class ProcessCreateRequest {
  final String title;
  final String description;
  final int userIdProcess;
  final int levelId;
  final DateTime dateExpired;
  final int statusId;
  final int typeSourceId;
  final String codeReference;
  final int conclusionId;
  final int kpiId;
  final List<String> attachments;

  const ProcessCreateRequest({
    required this.title,
    required this.description,
    required this.userIdProcess,
    required this.levelId,
    required this.dateExpired,
    this.statusId = 0,
    required this.typeSourceId,
    required this.codeReference,
    this.conclusionId = 0,
    this.kpiId = 0,
    this.attachments = const [],
  });

  Map<String, dynamic> toJson() {
    final expiredUtc = DateTime.utc(
      dateExpired.year,
      dateExpired.month,
      dateExpired.day,
    );
    return {
      'Title': title,
      'Description': description,
      'UserIDProcess': userIdProcess,
      'LevelID': levelId,
      'DateExpired': expiredUtc.toIso8601String(),
      'StatusID': statusId,
      'TypeSourceID': typeSourceId,
      'CodeReference': codeReference,
      'ConclusionID': conclusionId,
      'KPIID': kpiId,
      'lstAttachment': attachments,
    };
  }
}

class ProcessCreatedItem {
  final int processId;
  final String title;
  final String userNameProcess;
  final String levelName;
  final String statusName;
  final String typeSourceName;

  const ProcessCreatedItem({
    required this.processId,
    required this.title,
    required this.userNameProcess,
    required this.levelName,
    required this.statusName,
    required this.typeSourceName,
  });

  factory ProcessCreatedItem.fromJson(Map<String, dynamic> json) {
    return ProcessCreatedItem(
      processId: _asInt(json['ProcessID']),
      title: json['Title'] as String? ?? '',
      userNameProcess: json['UserNameProcess'] as String? ?? '',
      levelName: json['LevelName'] as String? ?? '',
      statusName: json['StatusName'] as String? ?? '',
      typeSourceName: json['TypeSourceName'] as String? ?? '',
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

double _asDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
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
