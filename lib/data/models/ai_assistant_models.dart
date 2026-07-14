class AiHistoryItem {
  final int historyChatId;
  final String title;

  const AiHistoryItem({required this.historyChatId, required this.title});

  factory AiHistoryItem.fromJson(Map<String, dynamic> json) {
    return AiHistoryItem(
      historyChatId: _aiInt(json['HistoryChatID']),
      title: (json['Title'] as String? ?? '').trim(),
    );
  }
}

class AiHistoryPage {
  final int totals;
  final List<AiHistoryItem> items;

  const AiHistoryPage({required this.totals, required this.items});

  factory AiHistoryPage.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return AiHistoryPage(
      totals: _aiInt(json['totals']),
      items: raw is List
          ? raw
                .whereType<Map>()
                .map(
                  (item) =>
                      AiHistoryItem.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : const [],
    );
  }

  factory AiHistoryPage.empty() => const AiHistoryPage(totals: 0, items: []);
}

class AiChatMessage {
  final String id;
  final AiChatRole role;
  final String content;
  final DateTime createdAt;

  const AiChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  AiChatMessage copyWith({String? content}) {
    return AiChatMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role.name,
    'content': content,
    'timestamp':
        '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}',
  };
}

enum AiChatRole { user, assistant }

class AiMonthlyKpiItem {
  final String name;
  final String departmentName;
  final num target;
  final num reality;
  final String unit;
  final String statusName;

  const AiMonthlyKpiItem({
    required this.name,
    required this.departmentName,
    required this.target,
    required this.reality,
    required this.unit,
    required this.statusName,
  });

  factory AiMonthlyKpiItem.fromJson(Map<String, dynamic> json) {
    return AiMonthlyKpiItem(
      name: (json['KPIName'] as String? ?? '').trim(),
      departmentName: (json['DepartmentName'] as String? ?? '').trim(),
      target: _aiNum(json['Target']),
      reality: _aiNum(json['Reality']),
      unit: (json['Unit'] as String? ?? '').trim(),
      statusName: (json['StatusName'] as String? ?? '').trim(),
    );
  }
}

class AiMonthlyKpiSummary {
  final int month;
  final int year;
  final int totalKpi;
  final int onTrack;
  final int atRisk;
  final int completed;
  final int delayed;
  final num completionRate;
  final num atRiskRate;
  final List<AiMonthlyKpiItem> kpis;

  const AiMonthlyKpiSummary({
    required this.month,
    required this.year,
    required this.totalKpi,
    required this.onTrack,
    required this.atRisk,
    required this.completed,
    required this.delayed,
    required this.completionRate,
    required this.atRiskRate,
    required this.kpis,
  });

  factory AiMonthlyKpiSummary.fromJson(Map<String, dynamic> json) {
    final raw = json['KPIs'];
    return AiMonthlyKpiSummary(
      month: _aiInt(json['Month']),
      year: _aiInt(json['Year']),
      totalKpi: _aiInt(json['TotalKPI']),
      onTrack: _aiInt(json['OnTrack']),
      atRisk: _aiInt(json['AtRisk']),
      completed: _aiInt(json['Completed']),
      delayed: _aiInt(json['Delayed']),
      completionRate: _aiNum(json['CompletionRate']),
      atRiskRate: _aiNum(json['AtRiskRate']),
      kpis: raw is List
          ? raw
                .whereType<Map>()
                .map(
                  (item) => AiMonthlyKpiItem.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class AiMonthlyProcessItem {
  final String title;
  final String userNameProcess;
  final String levelName;
  final DateTime? dateExpired;
  final String statusName;
  final String description;
  final String typeSourceName;
  final String codeReference;

  const AiMonthlyProcessItem({
    required this.title,
    required this.userNameProcess,
    required this.levelName,
    required this.dateExpired,
    required this.statusName,
    required this.description,
    required this.typeSourceName,
    required this.codeReference,
  });

  factory AiMonthlyProcessItem.fromJson(Map<String, dynamic> json) =>
      AiMonthlyProcessItem(
        title: (json['Title'] as String? ?? '').trim(),
        userNameProcess: (json['UserNameProcess'] as String? ?? '').trim(),
        levelName: (json['LevelName'] as String? ?? '').trim(),
        dateExpired: DateTime.tryParse('${json['DateExpired'] ?? ''}'),
        statusName: (json['StatusName'] as String? ?? '').trim(),
        description: (json['Description'] as String? ?? '').trim(),
        typeSourceName: (json['TypeSourceName'] as String? ?? '').trim(),
        codeReference: (json['CodeReference'] as String? ?? '').trim(),
      );
}

class AiMonthlyProcessSummary {
  final int month;
  final int year;
  final int total;
  final int notStarted;
  final int inProgress;
  final int pendingApproval;
  final int completed;
  final int overdue;
  final List<AiMonthlyProcessItem> processes;

  const AiMonthlyProcessSummary({
    required this.month,
    required this.year,
    required this.total,
    required this.notStarted,
    required this.inProgress,
    required this.pendingApproval,
    required this.completed,
    required this.overdue,
    required this.processes,
  });

  factory AiMonthlyProcessSummary.fromJson(Map<String, dynamic> json) {
    final raw = json['Processes'];
    return AiMonthlyProcessSummary(
      month: _aiInt(json['Month']),
      year: _aiInt(json['Year']),
      total: _aiInt(json['Total']),
      notStarted: _aiInt(json['ChuaBatDau']),
      inProgress: _aiInt(json['DangThucHien']),
      pendingApproval: _aiInt(json['ChoDuyet']),
      completed: _aiInt(json['HoanThanh']),
      overdue: _aiInt(json['QuaHan']),
      processes: raw is List
          ? raw
                .whereType<Map>()
                .map(
                  (item) => AiMonthlyProcessItem.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class AiMonthlyResidenceSummary {
  final int month;
  final int year;
  final int totalPopulation;
  final int totalMale;
  final int totalFemale;
  final int totalChildren;
  final int totalElderly;
  final int totalHouseholds;
  final int poorHouseholds;
  final int policyHouseholds;
  final int newHouseholds;
  final int newMembers;

  const AiMonthlyResidenceSummary({
    required this.month,
    required this.year,
    required this.totalPopulation,
    required this.totalMale,
    required this.totalFemale,
    required this.totalChildren,
    required this.totalElderly,
    required this.totalHouseholds,
    required this.poorHouseholds,
    required this.policyHouseholds,
    required this.newHouseholds,
    required this.newMembers,
  });

  factory AiMonthlyResidenceSummary.fromJson(Map<String, dynamic> json) =>
      AiMonthlyResidenceSummary(
        month: _aiInt(json['Month']),
        year: _aiInt(json['Year']),
        totalPopulation: _aiInt(json['TotalPopulation']),
        totalMale: _aiInt(json['TotalMale']),
        totalFemale: _aiInt(json['TotalFemale']),
        totalChildren: _aiInt(json['TotalChildren']),
        totalElderly: _aiInt(json['TotalElderly']),
        totalHouseholds: _aiInt(json['TotalHouseholds']),
        poorHouseholds: _aiInt(json['PoorHouseholds']),
        policyHouseholds: _aiInt(json['PolicyHouseholds']),
        newHouseholds: _aiInt(json['NewHouseholdsThisMonth']),
        newMembers: _aiInt(json['NewMembersThisMonth']),
      );
}

class AiMonthlyBookingType {
  final String name;
  final int count;

  const AiMonthlyBookingType({required this.name, required this.count});

  factory AiMonthlyBookingType.fromJson(Map<String, dynamic> json) =>
      AiMonthlyBookingType(
        name: (json['TypeBookingName'] as String? ?? '').trim(),
        count: _aiInt(json['Count']),
      );
}

class AiMonthlyBookingSummary {
  final int month;
  final int year;
  final int total;
  final int upcoming;
  final int ongoing;
  final int ended;
  final int cancelled;
  final int participants;
  final int withConclusion;
  final int withoutConclusion;
  final List<AiMonthlyBookingType> byType;

  const AiMonthlyBookingSummary({
    required this.month,
    required this.year,
    required this.total,
    required this.upcoming,
    required this.ongoing,
    required this.ended,
    required this.cancelled,
    required this.participants,
    required this.withConclusion,
    required this.withoutConclusion,
    required this.byType,
  });

  factory AiMonthlyBookingSummary.fromJson(Map<String, dynamic> json) {
    final raw = json['ByType'];
    return AiMonthlyBookingSummary(
      month: _aiInt(json['Month']),
      year: _aiInt(json['Year']),
      total: _aiInt(json['TotalBooking']),
      upcoming: _aiInt(json['Upcoming']),
      ongoing: _aiInt(json['Ongoing']),
      ended: _aiInt(json['Ended']),
      cancelled: _aiInt(json['Cancelled']),
      participants: _aiInt(json['TotalParticipants']),
      withConclusion: _aiInt(json['WithConclusion']),
      withoutConclusion: _aiInt(json['WithoutConclusion']),
      byType: raw is List
          ? raw
                .whereType<Map>()
                .map(
                  (item) => AiMonthlyBookingType.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

int _aiInt(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;

num _aiNum(dynamic value) => value is num ? value : num.tryParse('$value') ?? 0;
