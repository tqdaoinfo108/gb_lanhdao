import 'dashboard_models.dart';

class OfficeLocation {
  final double? longitude;
  final double? latitude;
  final String wellKnownText;

  const OfficeLocation({
    required this.longitude,
    required this.latitude,
    required this.wellKnownText,
  });

  factory OfficeLocation.fromJson(Map<String, dynamic> json) {
    final geography = json['Geography'];
    final text = geography is Map
        ? geography['WellKnownText'] as String? ?? ''
        : json['WellKnownText'] as String? ?? '';
    final match = RegExp(r'POINT\s*\(([-\d.]+)\s+([-\d.]+)\)').firstMatch(text);
    return OfficeLocation(
      longitude: match == null ? null : double.tryParse(match.group(1)!),
      latitude: match == null ? null : double.tryParse(match.group(2)!),
      wellKnownText: text,
    );
  }
}

class OfficeItem {
  final int officeId;
  final int typeOfficeId;
  final String typeOfficeName;
  final int cityId;
  final String cityName;
  final int villageId;
  final String villageName;
  final String officeName;
  final String officeAddress;
  final String officeDescription;
  final OfficeLocation? location;
  final int statusId;
  final String statusName;

  const OfficeItem({
    required this.officeId,
    required this.typeOfficeId,
    required this.typeOfficeName,
    required this.cityId,
    required this.cityName,
    required this.villageId,
    required this.villageName,
    required this.officeName,
    required this.officeAddress,
    required this.officeDescription,
    required this.location,
    required this.statusId,
    required this.statusName,
  });

  bool get isActive => statusId == 1;

  String get displayStatus {
    if (statusName.trim().isNotEmpty) return statusName;
    return isActive ? 'Hoạt động' : 'Ngưng';
  }

  factory OfficeItem.fromJson(Map<String, dynamic> json) {
    final location = json['LocationGis'];
    return OfficeItem(
      officeId: _asInt(json['OfficeID']),
      typeOfficeId: _asInt(json['TypeOfficeID']),
      typeOfficeName: json['TypeOfficeName'] as String? ?? '',
      cityId: _asInt(json['CityID']),
      cityName: json['CityName'] as String? ?? '',
      villageId: _asInt(json['VillageID']),
      villageName: json['VillageName'] as String? ?? '',
      officeName: json['OfficeName'] as String? ?? 'Chưa đặt tên',
      officeAddress: json['OfficeAddress'] as String? ?? '',
      officeDescription: json['OfficeDescription'] as String? ?? '',
      location: location is Map
          ? OfficeLocation.fromJson(Map<String, dynamic>.from(location))
          : null,
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
    );
  }
}

class OfficePage {
  final int totals;
  final int totalActive;
  final int totalAll;
  final List<OfficeItem> offices;

  const OfficePage({
    required this.totals,
    required this.totalActive,
    required this.totalAll,
    required this.offices,
  });

  int get inactiveCount => totalAll - totalActive;

  factory OfficePage.empty() {
    return const OfficePage(
      totals: 0,
      totalActive: 0,
      totalAll: 0,
      offices: [],
    );
  }

  factory OfficePage.fromJson(Map<String, dynamic> json) {
    return OfficePage(
      totals: _asInt(json['totals']),
      totalActive: _asInt(json['totalActive']),
      totalAll: _asInt(json['totalAll']),
      offices: _asList(
        json['data'],
      ).map((item) => OfficeItem.fromJson(item)).toList(),
    );
  }
}

class OfficeBundle {
  final OfficePage officePage;
  final DashboardNotificationPage notifications;

  const OfficeBundle({required this.officePage, required this.notifications});

  factory OfficeBundle.empty() {
    return OfficeBundle(
      officePage: OfficePage.empty(),
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

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}
