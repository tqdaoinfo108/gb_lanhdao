import '../../widgets/admin_smart_ui.dart';

class ResidenceVillageHousehold {
  final int houseHoldId;
  final int userId;
  final String userNameLeader;
  final String headHouseHold;
  final String statusName;
  final String phone;
  final String address;

  const ResidenceVillageHousehold({
    required this.houseHoldId,
    required this.userId,
    required this.userNameLeader,
    required this.headHouseHold,
    required this.statusName,
    required this.phone,
    required this.address,
  });

  factory ResidenceVillageHousehold.fromJson(Map<String, dynamic> json) {
    return ResidenceVillageHousehold(
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

class ResidenceVillage {
  final int villageId;
  final String villageName;
  final String description;
  final int statusId;
  final String statusName;
  final int totalHouseHold;
  final int totalMember;
  final List<ResidenceVillageHousehold> households;

  const ResidenceVillage({
    required this.villageId,
    required this.villageName,
    required this.description,
    required this.statusId,
    required this.statusName,
    required this.totalHouseHold,
    required this.totalMember,
    required this.households,
  });

  factory ResidenceVillage.fromJson(Map<String, dynamic> json) {
    return ResidenceVillage(
      villageId: _asInt(json['VillageID']),
      villageName: json['VillageName'] as String? ?? '',
      description: json['Description'] as String? ?? '',
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
      totalHouseHold: _asInt(json['TotalHouseHold']),
      totalMember: _asInt(json['TotalMember']),
      households: _asList(
        json['lstHouseHold'],
      ).map(ResidenceVillageHousehold.fromJson).toList(),
    );
  }
}

class ResidenceVillagePage {
  final int totals;
  final List<ResidenceVillage> villages;

  const ResidenceVillagePage({required this.totals, required this.villages});

  factory ResidenceVillagePage.empty() {
    return const ResidenceVillagePage(totals: 0, villages: []);
  }

  factory ResidenceVillagePage.fromJson(Map<String, dynamic> json) {
    return ResidenceVillagePage(
      totals: _asInt(json['totals']),
      villages: _asList(json['data']).map(ResidenceVillage.fromJson).toList(),
    );
  }
}

class HouseholdItem {
  final int houseHoldId;
  final int? parentId;
  final String parentHeadHouseHold;
  final int userId;
  final String userNameLeader;
  final int villageId;
  final String villageName;
  final int typeHouseHoldId;
  final String typeHouseHoldName;
  final String headHouseHold;
  final DateTime? dateRegister;
  final int statusId;
  final String statusName;
  final int numberPerson;
  final String phone;
  final String address;
  final String description;
  final int numberOfChildren;
  final int numberOfElderly;

  const HouseholdItem({
    required this.houseHoldId,
    required this.parentId,
    required this.parentHeadHouseHold,
    required this.userId,
    required this.userNameLeader,
    required this.villageId,
    required this.villageName,
    required this.typeHouseHoldId,
    required this.typeHouseHoldName,
    required this.headHouseHold,
    required this.dateRegister,
    required this.statusId,
    required this.statusName,
    required this.numberPerson,
    required this.phone,
    required this.address,
    required this.description,
    required this.numberOfChildren,
    required this.numberOfElderly,
  });

  bool get isActive => statusId == 1;

  bool get hasChildren => numberOfChildren > 0;

  bool get hasElderly => numberOfElderly > 0;

  SmartTone get statusTone => isActive ? SmartTone.success : SmartTone.danger;

  SmartTone get typeTone {
    final normalized = typeHouseHoldName.toLowerCase();
    if (normalized.contains('ngheo') || normalized.contains('nghèo')) {
      return SmartTone.danger;
    }
    if (normalized.contains('can ngheo') || normalized.contains('cận nghèo')) {
      return SmartTone.warning;
    }
    if (normalized.contains('chinh sach') ||
        normalized.contains('chính sách')) {
      return SmartTone.accent;
    }
    return SmartTone.neutral;
  }

  String get displayStatus {
    if (statusName.trim().isNotEmpty) return statusName;
    return isActive ? 'Hoạt động' : 'Ngưng hoạt động';
  }

  String get displayType {
    return typeHouseHoldName.trim().isEmpty
        ? 'Chưa phân loại'
        : typeHouseHoldName;
  }

  factory HouseholdItem.fromJson(Map<String, dynamic> json) {
    return HouseholdItem(
      houseHoldId: _asInt(json['HouseHoldID']),
      parentId: json['ParentID'] == null ? null : _asInt(json['ParentID']),
      parentHeadHouseHold: json['ParentHeadHouseHold'] as String? ?? '',
      userId: _asInt(json['UserID']),
      userNameLeader: json['UserNameLeader'] as String? ?? '',
      villageId: _asInt(json['VillageID']),
      villageName: json['VillageName'] as String? ?? '',
      typeHouseHoldId: _asInt(json['TypeHouseHoldID']),
      typeHouseHoldName: json['TypeHouseHoldName'] as String? ?? '',
      headHouseHold: json['HeadHouseHold'] as String? ?? '',
      dateRegister: _asDate(json['DateRegister']),
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
      numberPerson: _asInt(json['NumberPerson']),
      phone: json['Phone'] as String? ?? '',
      address: json['Address'] as String? ?? '',
      description: json['Description'] as String? ?? '',
      numberOfChildren: _asInt(json['NumberOfChildren']),
      numberOfElderly: _asInt(json['NumberOfElderly']),
    );
  }
}

class HouseholdPage {
  final int totals;
  final List<HouseholdItem> households;

  const HouseholdPage({required this.totals, required this.households});

  int get activeCount => households.where((item) => item.isActive).length;

  int get inactiveCount => households.length - activeCount;

  int get totalMembers {
    return households.fold(0, (total, item) => total + item.numberPerson);
  }

  factory HouseholdPage.empty() {
    return const HouseholdPage(totals: 0, households: []);
  }

  factory HouseholdPage.fromJson(Map<String, dynamic> json) {
    return HouseholdPage(
      totals: _asInt(json['totals']),
      households: _asList(json['data']).map(HouseholdItem.fromJson).toList(),
    );
  }
}

class HouseholdType {
  final int typeHouseHoldId;
  final String typeHouseHoldName;
  final String description;
  final int statusId;
  final String statusName;

  const HouseholdType({
    required this.typeHouseHoldId,
    required this.typeHouseHoldName,
    required this.description,
    required this.statusId,
    required this.statusName,
  });

  factory HouseholdType.fromJson(Map<String, dynamic> json) {
    return HouseholdType(
      typeHouseHoldId: _asInt(json['TypeHouseHoldID']),
      typeHouseHoldName: json['TypeHouseHoldName'] as String? ?? '',
      description: json['Description'] as String? ?? '',
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
    );
  }
}

class HouseholdTypePage {
  final int totals;
  final List<HouseholdType> types;

  const HouseholdTypePage({required this.totals, required this.types});

  factory HouseholdTypePage.empty() {
    return const HouseholdTypePage(totals: 0, types: []);
  }

  factory HouseholdTypePage.fromJson(Map<String, dynamic> json) {
    return HouseholdTypePage(
      totals: _asInt(json['totals']),
      types: _asList(json['data']).map(HouseholdType.fromJson).toList(),
    );
  }
}

class ResidenceBundle {
  final ResidenceVillagePage villages;
  final HouseholdPage households;
  final HouseholdTypePage types;

  const ResidenceBundle({
    required this.villages,
    required this.households,
    required this.types,
  });

  int get totalVillages => villages.villages.length;

  int get totalHouseholds {
    final fromVillage = villages.villages.fold(
      0,
      (total, village) => total + village.totalHouseHold,
    );
    return fromVillage > 0 ? fromVillage : households.totals;
  }

  int get totalMembers {
    final fromVillage = villages.villages.fold(
      0,
      (total, village) => total + village.totalMember,
    );
    return fromVillage > 0 ? fromVillage : households.totalMembers;
  }

  int householdCountByType(int typeId) {
    return households.households
        .where((item) => item.typeHouseHoldId == typeId)
        .length;
  }

  factory ResidenceBundle.empty() {
    return ResidenceBundle(
      villages: ResidenceVillagePage.empty(),
      households: HouseholdPage.empty(),
      types: HouseholdTypePage.empty(),
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
