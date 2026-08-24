class QualityTemplate {
  final int id;
  final String name;
  final DateTime? start;
  final DateTime? end;

  const QualityTemplate({
    required this.id,
    required this.name,
    this.start,
    this.end,
  });

  factory QualityTemplate.fromJson(Map<String, dynamic> json) =>
      QualityTemplate(
        id: _asInt(json['TemplateID']),
        name: json['TemplateName'] as String? ?? 'Mẫu đánh giá',
        start: _asDate(json['TimeStart']),
        end: _asDate(json['TimeEnd']),
      );
}

class QualityStaff {
  final int id;
  final String fullName;
  final String userName;
  final String departmentName;

  const QualityStaff({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.departmentName,
  });

  String get displayName => fullName.trim().isEmpty ? userName : fullName;

  factory QualityStaff.fromJson(Map<String, dynamic> json) => QualityStaff(
    id: _asInt(json['UserID']),
    fullName: json['FullName'] as String? ?? '',
    userName: json['UserName'] as String? ?? '',
    departmentName: json['DepartmentName'] as String? ?? '',
  );
}

class QualityReportItem {
  final int id;
  final String userName;
  final String fullName;
  final String departmentName;
  final String positionName;
  final DateTime? dateScoring;
  final double selfScore;
  final double leaderScore;
  final String classification;
  final DateTime? dateApproved;
  final String approver;
  final String statusName;

  const QualityReportItem({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.departmentName,
    required this.positionName,
    this.dateScoring,
    required this.selfScore,
    required this.leaderScore,
    required this.classification,
    this.dateApproved,
    required this.approver,
    required this.statusName,
  });

  factory QualityReportItem.fromJson(Map<String, dynamic> json) =>
      QualityReportItem(
        id: _asInt(json['ReportUserScoringID']),
        userName: json['UserName'] as String? ?? '',
        fullName: json['FullName'] as String? ?? '',
        departmentName: json['DepartmentName'] as String? ?? '',
        positionName: json['PositionName'] as String? ?? '',
        dateScoring: _asDate(json['DateScoring']),
        selfScore: _asDouble(json['DiemTuDanhGia']),
        leaderScore: _asDouble(json['DiemLanhDao']),
        classification: json['XepLoai'] as String? ?? 'Chưa xếp loại',
        dateApproved: _asDate(json['DateApprove']),
        approver: json['UserApprove'] as String? ?? '',
        statusName: json['StatusName'] as String? ?? '',
      );
}

class QualityReportPage {
  final int total;
  final List<QualityReportItem> items;

  const QualityReportPage({required this.total, required this.items});

  factory QualityReportPage.empty() =>
      const QualityReportPage(total: 0, items: []);

  factory QualityReportPage.fromJson(Map<String, dynamic> json) =>
      QualityReportPage(
        total: _asInt(json['totals']),
        items: _asList(json['data']).map(QualityReportItem.fromJson).toList(),
      );
}

class QualityReportBundle {
  final List<QualityTemplate> templates;
  final List<QualityStaff> staff;
  final QualityReportPage report;

  const QualityReportBundle({
    required this.templates,
    required this.staff,
    required this.report,
  });

  factory QualityReportBundle.empty() => QualityReportBundle(
    templates: const [],
    staff: const [],
    report: QualityReportPage.empty(),
  );
}

class QualityYearReportItem {
  final int id;
  final String userName;
  final String fullName;
  final String departmentName;
  final String positionName;
  final int totalPeriods;
  final double averageYear;
  final String classification;
  final int excellentMonths;
  final int goodMonths;
  final int completedMonths;
  final int incompleteMonths;
  final DateTime? dateApproved;
  final String approver;
  final String statusName;

  const QualityYearReportItem({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.departmentName,
    required this.positionName,
    required this.totalPeriods,
    required this.averageYear,
    required this.classification,
    required this.excellentMonths,
    required this.goodMonths,
    required this.completedMonths,
    required this.incompleteMonths,
    this.dateApproved,
    required this.approver,
    required this.statusName,
  });

  factory QualityYearReportItem.fromJson(Map<String, dynamic> json) =>
      QualityYearReportItem(
        id: _asInt(json['ReportYearID']),
        userName: json['UserName'] as String? ?? '',
        fullName: json['FullName'] as String? ?? '',
        departmentName: json['DepartmentName'] as String? ?? '',
        positionName: json['PositionName'] as String? ?? '',
        totalPeriods: _asInt(json['TongSoKy']),
        averageYear: _asDouble(json['AverageYear']),
        classification: json['XepLoai'] as String? ?? 'Chưa xếp loại',
        excellentMonths: _asInt(json['SoThangXuatSac']),
        goodMonths: _asInt(json['SoThangHoanThanhTot']),
        completedMonths: _asInt(json['SoThangHoanThanh']),
        incompleteMonths: _asInt(json['SoThangKhongHoanThanh']),
        dateApproved: _asDate(json['DateApprove']),
        approver: json['UserApprove'] as String? ?? '',
        statusName: json['StatusName'] as String? ?? '',
      );
}

class QualityYearReportPage {
  final int total;
  final List<QualityYearReportItem> items;

  const QualityYearReportPage({required this.total, required this.items});

  factory QualityYearReportPage.empty() =>
      const QualityYearReportPage(total: 0, items: []);

  factory QualityYearReportPage.fromJson(Map<String, dynamic> json) =>
      QualityYearReportPage(
        total: _asInt(json['totals']),
        items: _asList(
          json['data'],
        ).map(QualityYearReportItem.fromJson).toList(),
      );
}

class QualityYearReportBundle {
  final List<QualityStaff> staff;
  final QualityYearReportPage report;

  const QualityYearReportBundle({required this.staff, required this.report});

  factory QualityYearReportBundle.empty() => QualityYearReportBundle(
    staff: const [],
    report: QualityYearReportPage.empty(),
  );
}

int _asInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime? _asDate(dynamic value) => DateTime.tryParse(value?.toString() ?? '');

List<Map<String, dynamic>> _asList(dynamic value) => value is List
    ? value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList()
    : const [];
