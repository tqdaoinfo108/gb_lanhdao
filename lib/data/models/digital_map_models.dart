import 'office_models.dart';

class MapCoordinate {
  final double longitude;
  final double latitude;

  const MapCoordinate({required this.longitude, required this.latitude});

  factory MapCoordinate.fromLocationGis(Map<String, dynamic> json) {
    final geography = json['Geography'];
    final text = geography is Map
        ? geography['WellKnownText'] as String? ?? ''
        : json['WellKnownText'] as String? ?? '';
    return MapCoordinate.fromWellKnownText(text);
  }

  factory MapCoordinate.fromWellKnownText(String text) {
    final match = RegExp(r'POINT\s*\(([-\d.]+)\s+([-\d.]+)\)').firstMatch(text);
    return MapCoordinate(
      longitude: match == null ? 0 : double.tryParse(match.group(1)!) ?? 0,
      latitude: match == null ? 0 : double.tryParse(match.group(2)!) ?? 0,
    );
  }

  bool get isValid => longitude != 0 && latitude != 0;
}

class VillageHouseHold {
  final int houseHoldId;
  final int userId;
  final String userNameLeader;
  final String headHouseHold;
  final String statusName;
  final String phone;
  final String address;

  const VillageHouseHold({
    required this.houseHoldId,
    required this.userId,
    required this.userNameLeader,
    required this.headHouseHold,
    required this.statusName,
    required this.phone,
    required this.address,
  });

  factory VillageHouseHold.fromJson(Map<String, dynamic> json) {
    return VillageHouseHold(
      houseHoldId: _asInt(json['HouseHoldID']),
      userId: _asInt(json['UserID']),
      userNameLeader: json['UserNameLeader'] as String? ?? '',
      headHouseHold: json['HeadHouseHold'] as String? ?? '',
      statusName: json['StatusName'] as String? ?? '',
      phone: json['Phone'] as String? ?? '',
      address: json['Address'] as String? ?? '',
    );
  }
}

class VillageItem {
  final int villageId;
  final String villageName;
  final String description;
  final int statusId;
  final String statusName;
  final int totalHouseHold;
  final int totalMember;
  final List<VillageHouseHold> houseHolds;

  const VillageItem({
    required this.villageId,
    required this.villageName,
    required this.description,
    required this.statusId,
    required this.statusName,
    required this.totalHouseHold,
    required this.totalMember,
    required this.houseHolds,
  });

  factory VillageItem.fromJson(Map<String, dynamic> json) {
    return VillageItem(
      villageId: _asInt(json['VillageID']),
      villageName: json['VillageName'] as String? ?? '',
      description: json['Description'] as String? ?? '',
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
      totalHouseHold: _asInt(json['TotalHouseHold']),
      totalMember: _asInt(json['TotalMember']),
      houseHolds: _asList(
        json['lstHouseHold'],
      ).map(VillageHouseHold.fromJson).toList(),
    );
  }
}

class VillagePage {
  final int totals;
  final List<VillageItem> villages;

  const VillagePage({required this.totals, required this.villages});

  factory VillagePage.empty() => const VillagePage(totals: 0, villages: []);

  factory VillagePage.fromJson(Map<String, dynamic> json) {
    return VillagePage(
      totals: _asInt(json['totals']),
      villages: _asList(json['data']).map(VillageItem.fromJson).toList(),
    );
  }
}

class TypeOfficeItem {
  final int typeOfficeId;
  final String typeOfficeName;
  final String description;
  final int statusId;
  final String statusName;
  final String imagePath;

  const TypeOfficeItem({
    required this.typeOfficeId,
    required this.typeOfficeName,
    required this.description,
    required this.statusId,
    required this.statusName,
    required this.imagePath,
  });

  factory TypeOfficeItem.fromJson(Map<String, dynamic> json) {
    return TypeOfficeItem(
      typeOfficeId: _asInt(json['TypeOfficeID']),
      typeOfficeName: json['TypeOfficeName'] as String? ?? '',
      description: json['Description'] as String? ?? '',
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
      imagePath: json['ImagePath'] as String? ?? '',
    );
  }
}

class TypeOfficePage {
  final int totals;
  final List<TypeOfficeItem> types;

  const TypeOfficePage({required this.totals, required this.types});

  factory TypeOfficePage.empty() => const TypeOfficePage(totals: 0, types: []);

  factory TypeOfficePage.fromJson(Map<String, dynamic> json) {
    return TypeOfficePage(
      totals: _asInt(json['totals']),
      types: _asList(json['data']).map(TypeOfficeItem.fromJson).toList(),
    );
  }
}

class WardPointItem {
  final int wardPointId;
  final int wardId;
  final int order;
  final MapCoordinate coordinate;

  const WardPointItem({
    required this.wardPointId,
    required this.wardId,
    required this.order,
    required this.coordinate,
  });

  factory WardPointItem.fromJson(Map<String, dynamic> json) {
    final location = json['LocationGis'];
    return WardPointItem(
      wardPointId: _asInt(json['WardPointID']),
      wardId: _asInt(json['WardID']),
      order: _asInt(json['Order']),
      coordinate: location is Map
          ? MapCoordinate.fromLocationGis(Map<String, dynamic>.from(location))
          : const MapCoordinate(longitude: 0, latitude: 0),
    );
  }
}

class WardItem {
  final int wardId;
  final String wardName;
  final String description;
  final int statusId;
  final String statusName;
  final List<WardPointItem> points;

  const WardItem({
    required this.wardId,
    required this.wardName,
    required this.description,
    required this.statusId,
    required this.statusName,
    required this.points,
  });

  List<MapCoordinate> get boundary {
    final sorted = [...points]..sort((a, b) => a.order.compareTo(b.order));
    return sorted
        .map((point) => point.coordinate)
        .where((coordinate) => coordinate.isValid)
        .toList();
  }

  factory WardItem.fromJson(Map<String, dynamic> json) {
    return WardItem(
      wardId: _asInt(json['WardID']),
      wardName: json['WardName'] as String? ?? '',
      description: json['Description'] as String? ?? '',
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
      points: _asList(
        json['lstWardPoint'],
      ).map(WardPointItem.fromJson).toList(),
    );
  }
}

class WardPage {
  final int totals;
  final List<WardItem> wards;

  const WardPage({required this.totals, required this.wards});

  factory WardPage.empty() => const WardPage(totals: 0, wards: []);

  factory WardPage.fromJson(Map<String, dynamic> json) {
    return WardPage(
      totals: _asInt(json['totals']),
      wards: _asList(json['data']).map(WardItem.fromJson).toList(),
    );
  }
}

class DigitalMapBundle {
  final VillagePage villages;
  final OfficePage offices;
  final TypeOfficePage officeTypes;
  final WardPage wards;

  const DigitalMapBundle({
    required this.villages,
    required this.offices,
    required this.officeTypes,
    required this.wards,
  });

  factory DigitalMapBundle.empty() {
    return DigitalMapBundle(
      villages: VillagePage.empty(),
      offices: OfficePage.empty(),
      officeTypes: TypeOfficePage.empty(),
      wards: WardPage.empty(),
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
