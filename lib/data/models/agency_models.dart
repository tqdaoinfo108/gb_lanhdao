import 'dashboard_models.dart';

class AgencyItem {
  final int agencyId;
  final String agencyName;
  final int statusId;
  final String statusName;
  final String description;
  final String userCreated;
  final String userUpdated;
  final DateTime? dateCreated;
  final DateTime? dateUpdated;

  const AgencyItem({
    required this.agencyId,
    required this.agencyName,
    required this.statusId,
    required this.statusName,
    required this.description,
    required this.userCreated,
    required this.userUpdated,
    required this.dateCreated,
    required this.dateUpdated,
  });

  bool get isActive => statusId == 1;

  String get displayStatus {
    if (statusName.trim().isNotEmpty) return statusName;
    return isActive ? 'Hoạt động' : 'Ngưng';
  }

  factory AgencyItem.fromJson(Map<String, dynamic> json) {
    return AgencyItem(
      agencyId: _asInt(json['AgencyID']),
      agencyName: json['AgencyName'] as String? ?? 'Chưa đặt tên',
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
      description: json['Description'] as String? ?? '',
      userCreated: json['UserCreated'] as String? ?? '',
      userUpdated: json['UserUpdated'] as String? ?? '',
      dateCreated: _asDate(json['DateCreated']),
      dateUpdated: _asDate(json['DateUpdated']),
    );
  }
}

class AgencyPage {
  final int totals;
  final int totalActive;
  final int totalAll;
  final List<AgencyItem> agencies;

  const AgencyPage({
    required this.totals,
    required this.totalActive,
    required this.totalAll,
    required this.agencies,
  });

  int get inactiveCount => totalAll - totalActive;

  factory AgencyPage.empty() {
    return const AgencyPage(
      totals: 0,
      totalActive: 0,
      totalAll: 0,
      agencies: [],
    );
  }

  factory AgencyPage.fromJson(Map<String, dynamic> json) {
    return AgencyPage(
      totals: _asInt(json['totals']),
      totalActive: _asInt(json['totalActive']),
      totalAll: _asInt(json['totalAll']),
      agencies: _asList(
        json['data'],
      ).map((item) => AgencyItem.fromJson(item)).toList(),
    );
  }
}

class AgencyBundle {
  final AgencyPage agencyPage;
  final DashboardNotificationPage notifications;

  const AgencyBundle({required this.agencyPage, required this.notifications});

  factory AgencyBundle.empty() {
    return AgencyBundle(
      agencyPage: AgencyPage.empty(),
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
