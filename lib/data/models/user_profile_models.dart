/// Model cho thông tin người dùng đăng nhập.
/// Map với API: GET /user/profile và POST /user/update-user.
class UserPermission {
  final int userModuleId;
  final int moduleId;
  final String moduleName;
  final int userId;
  final String userName;
  final String fullName;
  final int isView;
  final int isInsert;
  final int isDelete;
  final int isUpdate;
  final int isApproval;

  const UserPermission({
    required this.userModuleId,
    required this.moduleId,
    required this.moduleName,
    required this.userId,
    required this.userName,
    required this.fullName,
    required this.isView,
    required this.isInsert,
    required this.isDelete,
    required this.isUpdate,
    required this.isApproval,
  });

  factory UserPermission.fromJson(Map<String, dynamic> json) {
    return UserPermission(
      userModuleId: _asInt(json['UserMoudleID']),
      moduleId: _asInt(json['ModuleID']),
      moduleName: json['ModuleName'] as String? ?? '',
      userId: _asInt(json['UserID']),
      userName: json['UserName'] as String? ?? '',
      fullName: json['FullName'] as String? ?? '',
      isView: _asInt(json['IsView']),
      isInsert: _asInt(json['IsInsert']),
      isDelete: _asInt(json['IsDelete']),
      isUpdate: _asInt(json['IsUpdate']),
      isApproval: _asInt(json['IsApproval']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserMoudleID': userModuleId,
      'ModuleID': moduleId,
      'ModuleName': moduleName,
      'UserID': userId,
      'UserName': userName,
      'FullName': fullName,
      'IsView': isView,
      'IsInsert': isInsert,
      'IsDelete': isDelete,
      'IsUpdate': isUpdate,
      'IsApproval': isApproval,
    };
  }
}

class UserProfile {
  final int userId;
  final int userTypeId;
  final int? householdId;
  final String householdName;
  final int positionId;
  final String positionName;
  final int departmentId;
  final String departmentName;
  final String userName;
  final String fullName;
  final int genderId;
  final String email;
  final String phone;
  final String address;
  final int statusId;
  final String statusName;
  final String imagePath;
  final DateTime? birthday;
  final String relationShip;
  final String tokenId;
  final List<UserPermission> permissions;

  const UserProfile({
    required this.userId,
    required this.userTypeId,
    required this.householdId,
    required this.householdName,
    required this.positionId,
    required this.positionName,
    required this.departmentId,
    required this.departmentName,
    required this.userName,
    required this.fullName,
    required this.genderId,
    required this.email,
    required this.phone,
    required this.address,
    required this.statusId,
    required this.statusName,
    required this.imagePath,
    required this.birthday,
    required this.relationShip,
    required this.tokenId,
    required this.permissions,
  });

  bool get isActive => statusId == 1;

  String get genderName {
    switch (genderId) {
      case 1:
        return 'Nam';
      case 2:
        return 'Nữ';
      default:
        return 'Khác';
    }
  }

  String get initials {
    final source = fullName.trim().isNotEmpty ? fullName.trim() : userName.trim();
    if (source.isEmpty) return 'U';
    final parts = source.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final word = parts.first;
      return (word.length >= 2 ? word.substring(0, 2) : word).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  factory UserProfile.empty() {
    return const UserProfile(
      userId: 0,
      userTypeId: 0,
      householdId: null,
      householdName: '',
      positionId: 0,
      positionName: '',
      departmentId: 0,
      departmentName: '',
      userName: '',
      fullName: '',
      genderId: 0,
      email: '',
      phone: '',
      address: '',
      statusId: 0,
      statusName: '',
      imagePath: '',
      birthday: null,
      relationShip: '',
      tokenId: '',
      permissions: [],
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: _asInt(json['UserID']),
      userTypeId: _asInt(json['UserTypeID']),
      householdId: json['HouseHoldID'] == null
          ? null
          : _asInt(json['HouseHoldID']),
      householdName: json['HouseHoldName'] as String? ?? '',
      positionId: _asInt(json['PositionID']),
      positionName: json['PositionName'] as String? ?? '',
      departmentId: _asInt(json['DepartmentID']),
      departmentName: json['DepartmentName'] as String? ?? '',
      userName: json['UserName'] as String? ?? '',
      fullName: json['FullName'] as String? ?? '',
      genderId: _asInt(json['GenderID']),
      email: json['Email'] as String? ?? '',
      phone: json['Phone'] as String? ?? '',
      address: json['Address'] as String? ?? '',
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
      imagePath: json['ImagePath'] as String? ?? '',
      birthday: _asDate(json['Birthday']),
      relationShip: json['RelationShip'] as String? ?? '',
      tokenId: json['TokenID'] as String? ?? '',
      permissions: _asList(json['lstPermission'])
          .map(UserPermission.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userId,
      'UserTypeID': userTypeId,
      'HouseHoldID': householdId,
      'HouseHoldName': householdName,
      'PositionID': positionId,
      'PositionName': positionName,
      'DepartmentID': departmentId,
      'DepartmentName': departmentName,
      'UserName': userName,
      'FullName': fullName,
      'GenderID': genderId,
      'Email': email,
      'Phone': phone,
      'Address': address,
      'StatusID': statusId,
      'StatusName': statusName,
      'ImagePath': imagePath,
      'Birthday': birthday?.toIso8601String(),
      'RelationShip': relationShip,
      'TokenID': tokenId,
      'lstPermission': permissions.map((item) => item.toJson()).toList(),
    };
  }

  /// Tạo bản sao có sửa đổi để phục vụ cập nhật hồ sơ.
  UserProfile copyWith({
    String? fullName,
    int? genderId,
    String? email,
    String? phone,
    String? address,
    DateTime? birthday,
  }) {
    return UserProfile(
      userId: userId,
      userTypeId: userTypeId,
      householdId: householdId,
      householdName: householdName,
      positionId: positionId,
      positionName: positionName,
      departmentId: departmentId,
      departmentName: departmentName,
      userName: userName,
      fullName: fullName ?? this.fullName,
      genderId: genderId ?? this.genderId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      statusId: statusId,
      statusName: statusName,
      imagePath: imagePath,
      birthday: birthday ?? this.birthday,
      relationShip: relationShip,
      tokenId: tokenId,
      permissions: permissions,
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
