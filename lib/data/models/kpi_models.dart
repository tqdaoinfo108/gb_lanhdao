class KpiMonthlyPoint {
  final String month;
  final int completed;
  final int onTrack;
  final int atRisk;
  final int delayed;

  const KpiMonthlyPoint({
    required this.month,
    required this.completed,
    required this.onTrack,
    required this.atRisk,
    required this.delayed,
  });

  int get maxValue => [
    completed,
    onTrack,
    atRisk,
    delayed,
  ].reduce((current, next) => current > next ? current : next);

  factory KpiMonthlyPoint.fromJson(Map<String, dynamic> json) {
    return KpiMonthlyPoint(
      month: json['month'] as String? ?? '',
      completed: _asInt(json['completed']),
      onTrack: _asInt(json['onTrack']),
      atRisk: _asInt(json['atRisk']),
      delayed: _asInt(json['delayed']),
    );
  }
}

class KpiProgramItem {
  final int kpiId;
  final String kpiName;
  final int categoryKpiId;
  final String categoryKpiName;
  final int departmentId;
  final String departmentName;
  final int userId;
  final String fullName;
  final double target;
  final double reality;
  final String unit;
  final DateTime? dateExpired;
  final int statusId;
  final String statusName;
  final String description;

  const KpiProgramItem({
    required this.kpiId,
    required this.kpiName,
    required this.categoryKpiId,
    required this.categoryKpiName,
    required this.departmentId,
    required this.departmentName,
    required this.userId,
    required this.fullName,
    required this.target,
    required this.reality,
    required this.unit,
    required this.dateExpired,
    required this.statusId,
    required this.statusName,
    required this.description,
  });

  String get ownerName =>
      fullName.trim().isNotEmpty ? fullName : 'Chưa xác định';

  String get scopeLabel {
    final department = departmentName.trim();
    final category = categoryKpiName.trim();
    if (department.isEmpty && category.isEmpty) return 'Chưa phân loại';
    if (department.isEmpty) return category;
    if (category.isEmpty) return department;
    return '$department · $category';
  }

  double get progressPercent {
    if (unit.trim() == '%') {
      return reality.clamp(0, 100);
    }
    if (target <= 0) return 0;
    return ((reality / target) * 100).clamp(0, 100);
  }

  String get executionLabel {
    final targetText = _formatNumber(target);
    final realityText = _formatNumber(reality);
    final unitText = unit.trim();
    return '$realityText / $targetText${unitText.isEmpty ? '' : ' $unitText'}';
  }

  factory KpiProgramItem.fromJson(Map<String, dynamic> json) {
    return KpiProgramItem(
      kpiId: _asInt(json['KPIID']),
      kpiName: json['KPIName'] as String? ?? 'Chưa đặt tên',
      categoryKpiId: _asInt(json['CategoryKPIID']),
      categoryKpiName: json['CategoryKPIName'] as String? ?? '',
      departmentId: _asInt(json['DepartmentID']),
      departmentName: json['DepartmentName'] as String? ?? '',
      userId: _asInt(json['UserID']),
      fullName: json['FullName'] as String? ?? '',
      target: _asDouble(json['Target']),
      reality: _asDouble(json['Reality']),
      unit: json['Unit'] as String? ?? '',
      dateExpired: _asDate(json['DateExpired']),
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? 'Chưa xác định',
      description: json['Description'] as String? ?? '',
    );
  }
}

class KpiProcessItem {
  final int processId;
  final int kpiId;
  final String title;
  final int statusId;
  final String statusName;
  final DateTime? dateExpired;

  const KpiProcessItem({
    required this.processId,
    required this.kpiId,
    required this.title,
    required this.statusId,
    required this.statusName,
    required this.dateExpired,
  });

  bool get isDone => statusId == 3 || statusName.toLowerCase().contains('hoàn');

  bool get isLate {
    final status = statusName.toLowerCase();
    if (status.contains('chậm') || status.contains('quá')) return true;
    final due = dateExpired;
    if (due == null || isDone) return false;
    return due.isBefore(DateTime.now());
  }

  factory KpiProcessItem.fromJson(Map<String, dynamic> json) {
    return KpiProcessItem(
      processId: _asInt(json['ProcessID']),
      kpiId: _asInt(json['KPIID']),
      title: json['Title'] as String? ?? '',
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
      dateExpired: _asDate(json['DateExpired']),
    );
  }
}

class KpiDepartmentOption {
  final int departmentId;
  final String departmentName;

  const KpiDepartmentOption({
    required this.departmentId,
    required this.departmentName,
  });

  factory KpiDepartmentOption.fromJson(Map<String, dynamic> json) {
    return KpiDepartmentOption(
      departmentId: _asInt(json['DepartmentID']),
      departmentName: json['DepartmentName'] as String? ?? '',
    );
  }
}

class KpiUserOption {
  final int userId;
  final String fullName;
  final String departmentName;

  const KpiUserOption({
    required this.userId,
    required this.fullName,
    required this.departmentName,
  });

  factory KpiUserOption.fromJson(Map<String, dynamic> json) {
    return KpiUserOption(
      userId: _asInt(json['UserID']),
      fullName: json['FullName'] as String? ?? '',
      departmentName: json['DepartmentName'] as String? ?? '',
    );
  }
}

class KpiProgramViewItem {
  final KpiProgramItem program;
  final KpiUserOption? owner;
  final List<KpiProcessItem> processes;

  const KpiProgramViewItem({
    required this.program,
    required this.owner,
    required this.processes,
  });

  int get processTotal => processes.length;
  int get processDone => processes.where((item) => item.isDone).length;
  int get processLate => processes.where((item) => item.isLate).length;

  String get processSummary => '$processDone/$processTotal việc';
}

class KpiBundle {
  final List<KpiMonthlyPoint> chart;
  final List<KpiProgramItem> programs;
  final List<KpiDepartmentOption> departments;
  final List<KpiUserOption> users;
  final List<KpiProcessItem> processes;

  const KpiBundle({
    required this.chart,
    required this.programs,
    required this.departments,
    required this.users,
    required this.processes,
  });

  int get totalPrograms => programs.length;
  int get totalOnTrack => programs.where((item) => item.statusId == 1).length;
  int get totalCompleted => programs
      .where(
        (item) =>
            item.statusId == 3 ||
            item.statusName.toLowerCase().contains('hoàn thành'),
      )
      .length;
  int get totalDelayed => programs
      .where(
        (item) =>
            item.statusId == 4 ||
            item.statusName.toLowerCase().contains('chậm'),
      )
      .length;

  List<KpiProgramViewItem> get viewItems {
    return programs.map((program) {
      final owner = users.firstWhere(
        (user) => user.userId == program.userId,
        orElse: () => KpiUserOption(
          userId: program.userId,
          fullName: program.fullName,
          departmentName: program.departmentName,
        ),
      );
      final relatedProcesses = processes
          .where((process) => process.kpiId == program.kpiId)
          .toList();
      return KpiProgramViewItem(
        program: program,
        owner: owner,
        processes: relatedProcesses,
      );
    }).toList();
  }

  factory KpiBundle.empty() {
    return const KpiBundle(
      chart: [],
      programs: [],
      departments: [],
      users: [],
      processes: [],
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

String _formatNumber(double value) {
  if (value % 1 == 0) return value.round().toString();
  return value.toStringAsFixed(1);
}

List<Map<String, dynamic>> kpiJsonList(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}
