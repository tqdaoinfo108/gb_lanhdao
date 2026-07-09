import 'dashboard_models.dart';

class AlertGroupItem {
  final int groupId;
  final String groupName;
  final String groupDescription;
  final int statusId;

  const AlertGroupItem({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.statusId,
  });

  factory AlertGroupItem.fromJson(Map<String, dynamic> json) {
    return AlertGroupItem(
      groupId: _asInt(json['GroupID']),
      groupName: json['GroupName'] as String? ?? '',
      groupDescription: json['GroupDescription'] as String? ?? '',
      statusId: _asInt(json['StatusID']),
    );
  }
}

class AlertGroupPage {
  final int totals;
  final List<AlertGroupItem> groups;

  const AlertGroupPage({required this.totals, required this.groups});

  factory AlertGroupPage.empty() {
    return const AlertGroupPage(totals: 0, groups: []);
  }

  factory AlertGroupPage.fromJson(Map<String, dynamic> json) {
    return AlertGroupPage(
      totals: _asInt(json['totals']),
      groups: _asList(json['data']).map(AlertGroupItem.fromJson).toList(),
    );
  }
}

class InformationItem {
  final int informationId;
  final String title;
  final int levelId;
  final String levelName;
  final int typeInforId;
  final DateTime? timeSet;
  final int numberRemind;
  final int statusId;
  final String statusName;
  final String shortDescription;
  final String description;
  final List<int> groupIds;
  final List<String> filePaths;

  const InformationItem({
    required this.informationId,
    required this.title,
    required this.levelId,
    required this.levelName,
    required this.typeInforId,
    required this.timeSet,
    required this.numberRemind,
    required this.statusId,
    required this.statusName,
    required this.shortDescription,
    required this.description,
    required this.groupIds,
    required this.filePaths,
  });

  bool get isRead {
    final normalized = statusName.toLowerCase();
    return statusId == 1 ||
        normalized.contains('xem') ||
        normalized.contains('\u0111\u1ECDc');
  }

  bool get isUrgent {
    final normalized = '$title $levelName $shortDescription'.toLowerCase();
    return levelId >= 3 ||
        normalized.contains('kh\u1EA9n') ||
        normalized.contains('g\u1EA5p');
  }

  factory InformationItem.fromJson(Map<String, dynamic> json) {
    return InformationItem(
      informationId: _asInt(json['InformationID']),
      title: json['Title'] as String? ?? '',
      levelId: _asInt(json['LevelID']),
      levelName: json['LevelName'] as String? ?? '',
      typeInforId: _asInt(json['TypeInforID']),
      timeSet: _asDate(json['TimeSet']),
      numberRemind: _asInt(json['NumberRemind']),
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
      shortDescription: json['ShortDescription'] as String? ?? '',
      description: json['Description'] as String? ?? '',
      groupIds: _asRawList(json['lstGroupID']).map(_asInt).toList(),
      filePaths: _asRawList(json['lstFilePath'])
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList(),
    );
  }
}

class InformationPage {
  final int totals;
  final List<InformationItem> items;

  const InformationPage({required this.totals, required this.items});

  factory InformationPage.empty() {
    return const InformationPage(totals: 0, items: []);
  }

  factory InformationPage.fromJson(Map<String, dynamic> json) {
    return InformationPage(
      totals: _asInt(json['totals']),
      items: _asList(json['data']).map(InformationItem.fromJson).toList(),
    );
  }
}

class UrgentAlertBundle {
  final AlertGroupPage groups;
  final InformationPage information;
  final DashboardNotificationPage notifications;

  const UrgentAlertBundle({
    required this.groups,
    required this.information,
    required this.notifications,
  });

  factory UrgentAlertBundle.empty() {
    return UrgentAlertBundle(
      groups: AlertGroupPage.empty(),
      information: InformationPage.empty(),
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

List<dynamic> _asRawList(dynamic value) {
  if (value is! List) return const [];
  return value;
}

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}
