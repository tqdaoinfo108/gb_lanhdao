import 'package:flutter/material.dart';

import '../../widgets/admin_smart_ui.dart';

// ---------------------------------------------------------------------------
// Warning (Tố giác)
// ---------------------------------------------------------------------------

class WarningItem {
  final int warningId;
  final String warningCode;
  final String warningTitle;
  final String userSent;
  final DateTime? dateSent;
  final String phone;
  final int typeWarningId;
  final String typeWarningName;
  final int departmentId;
  final int userIdProcess;
  final int levelId;
  final int statusId;
  final String statusName;
  final String address;
  final double lat;
  final double lng;
  final bool isVisible;
  final int aiAnalysis;
  final String description;
  final List<String> attachments;

  const WarningItem({
    required this.warningId,
    required this.warningCode,
    required this.warningTitle,
    required this.userSent,
    required this.dateSent,
    required this.phone,
    required this.typeWarningId,
    required this.typeWarningName,
    required this.departmentId,
    required this.userIdProcess,
    required this.levelId,
    required this.statusId,
    required this.statusName,
    required this.address,
    required this.lat,
    required this.lng,
    required this.isVisible,
    required this.aiAnalysis,
    required this.description,
    required this.attachments,
  });

  /// Mức độ hiển thị: 1 = Thấp, 2 = Trung bình, 3 = Cao
  String get levelLabel {
    switch (levelId) {
      case 1:
        return 'Thấp';
      case 2:
        return 'Trung bình';
      case 3:
        return 'Cao';
      default:
        return 'Không rõ';
    }
  }

  SmartTone get levelTone {
    switch (levelId) {
      case 1:
        return SmartTone.success;
      case 2:
        return SmartTone.warning;
      case 3:
        return SmartTone.danger;
      default:
        return SmartTone.neutral;
    }
  }

  Color get levelColor {
    switch (levelId) {
      case 1:
        return SmartColors.success;
      case 2:
        return SmartColors.warning;
      case 3:
        return SmartColors.danger;
      default:
        return SmartColors.border;
    }
  }

  SmartTone get statusTone {
    switch (statusId) {
      case 1:
        return SmartTone.accent; // Tiếp nhận
      case 2:
        return SmartTone.warning; // Đang điều tra
      case 3:
        return SmartTone.success; // Đã xử lý
      case 4:
        return SmartTone.neutral; // Đơn trùng
      case 5:
        return SmartTone.danger; // Ngưng hoạt động
      default:
        return SmartTone.neutral;
    }
  }

  factory WarningItem.fromJson(Map<String, dynamic> json) {
    return WarningItem(
      warningId: _asInt(json['WarningID']),
      warningCode: json['WarningCode'] as String? ?? '',
      warningTitle: json['WarningTitle'] as String? ?? '',
      userSent: json['UserSent'] as String? ?? '',
      dateSent: _asDate(json['DateSent']),
      phone: json['Phone'] as String? ?? '',
      typeWarningId: _asInt(json['TypeWarningID']),
      typeWarningName: json['TypeWarningName'] as String? ?? '',
      departmentId: _asInt(json['DepartmentID']),
      userIdProcess: _asInt(json['UserIDProcess']),
      levelId: _asInt(json['LevelID']),
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? '',
      address: json['Address'] as String? ?? '',
      lat: _asDouble(json['Lat']),
      lng: _asDouble(json['Lng']),
      isVisible: json['IsVisible'] as bool? ?? true,
      aiAnalysis: _asInt(json['AIAnalysis']),
      description: json['Description'] as String? ?? '',
      attachments: _asRawList(json['lstWarningAttachment'])
          .map((item) {
            if (item is Map) {
              return item['FilePath']?.toString() ?? '';
            }
            return item.toString();
          })
          .where((item) => item.trim().isNotEmpty)
          .toList(),
    );
  }
}

class WarningAiAnalysis {
  final int departmentId;
  final String departmentName;
  final int levelId;
  final String levelName;
  final int typeWarningId;
  final String typeWarningName;
  final int aiAnalysis;
  final String rawAi;

  const WarningAiAnalysis({
    required this.departmentId,
    required this.departmentName,
    required this.levelId,
    required this.levelName,
    required this.typeWarningId,
    required this.typeWarningName,
    required this.aiAnalysis,
    required this.rawAi,
  });

  factory WarningAiAnalysis.empty() {
    return const WarningAiAnalysis(
      departmentId: 0,
      departmentName: '',
      levelId: 0,
      levelName: 'Không xác định',
      typeWarningId: 0,
      typeWarningName: '',
      aiAnalysis: 0,
      rawAi: '',
    );
  }

  factory WarningAiAnalysis.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : <String, dynamic>{};
    return WarningAiAnalysis(
      departmentId: _asInt(data['DepartmentID']),
      departmentName: data['DepartmentName'] as String? ?? '',
      levelId: _asInt(data['LevelID']),
      levelName: data['LevelName'] as String? ?? 'Không xác định',
      typeWarningId: _asInt(data['TypeWarningID']),
      typeWarningName: data['TypeWarningName'] as String? ?? '',
      aiAnalysis: _asInt(data['AIAnalysis']),
      rawAi: json['rawAI'] as String? ?? '',
    );
  }
}

class WarningCreateRequest {
  final String warningCode;
  final String warningTitle;
  final String userSent;
  final DateTime dateSent;
  final String phone;
  final int typeWarningId;
  final int departmentId;
  final int userIdProcess;
  final int levelId;
  final int statusId;
  final String address;
  final double lat;
  final double lng;
  final bool isVisible;
  final int aiAnalysis;
  final String description;
  final List<String> attachments;

  const WarningCreateRequest({
    required this.warningCode,
    required this.warningTitle,
    required this.userSent,
    required this.dateSent,
    required this.phone,
    required this.typeWarningId,
    required this.departmentId,
    required this.userIdProcess,
    required this.levelId,
    required this.statusId,
    required this.address,
    required this.lat,
    required this.lng,
    required this.isVisible,
    required this.aiAnalysis,
    required this.description,
    required this.attachments,
  });

  Map<String, dynamic> toJson() {
    return {
      'WarningCode': warningCode,
      'WarningTitle': warningTitle,
      'UserSent': userSent,
      'DateSent': dateSent.toUtc().toIso8601String(),
      'Phone': phone,
      'TypeWarningID': typeWarningId,
      'DepartmentID': departmentId,
      'UserIDProcess': userIdProcess,
      'LevelID': levelId,
      'StatusID': statusId,
      'Address': address,
      'Lat': lat,
      'Lng': lng,
      'IsVisible': isVisible,
      'AIAnalysis': aiAnalysis,
      'Description': description,
      // API tạo mới dùng lstAttachment; một số phiên bản backend đọc theo
      // tên collection trả về là lstWarningAttachment.
      'lstAttachment': attachments,
      'lstWarningAttachment': attachments,
    };
  }
}

class WarningPage {
  final int totals;
  final List<WarningItem> items;

  const WarningPage({required this.totals, required this.items});

  factory WarningPage.empty() => const WarningPage(totals: 0, items: []);

  factory WarningPage.fromJson(Map<String, dynamic> json) {
    return WarningPage(
      totals: _asInt(json['totals']),
      items: _asList(json['data']).map(WarningItem.fromJson).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Type Warning (Loại tố giác)
// ---------------------------------------------------------------------------

class TypeWarningItem {
  final int typeWarningId;
  final String typeWarningName;
  final int statusId;
  final String description;

  const TypeWarningItem({
    required this.typeWarningId,
    required this.typeWarningName,
    required this.statusId,
    required this.description,
  });

  factory TypeWarningItem.fromJson(Map<String, dynamic> json) {
    return TypeWarningItem(
      typeWarningId: _asInt(json['TypeWarningID']),
      typeWarningName: json['TypeWarningName'] as String? ?? '',
      statusId: _asInt(json['StatusID']),
      description: json['Description'] as String? ?? '',
    );
  }
}

class TypeWarningPage {
  final int totals;
  final List<TypeWarningItem> items;

  const TypeWarningPage({required this.totals, required this.items});

  factory TypeWarningPage.empty() =>
      const TypeWarningPage(totals: 0, items: []);

  factory TypeWarningPage.fromJson(Map<String, dynamic> json) {
    return TypeWarningPage(
      totals: _asInt(json['totals']),
      items: _asList(json['data']).map(TypeWarningItem.fromJson).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Department (Phòng ban)
// ---------------------------------------------------------------------------

class CrimeDepartmentItem {
  final int departmentId;
  final String departmentName;
  final String description;

  const CrimeDepartmentItem({
    required this.departmentId,
    required this.departmentName,
    required this.description,
  });

  factory CrimeDepartmentItem.fromJson(Map<String, dynamic> json) {
    return CrimeDepartmentItem(
      departmentId: _asInt(json['DepartmentID']),
      departmentName: json['DepartmentName'] as String? ?? '',
      description: json['Description'] as String? ?? '',
    );
  }
}

class CrimeDepartmentPage {
  final int totals;
  final List<CrimeDepartmentItem> items;

  const CrimeDepartmentPage({required this.totals, required this.items});

  factory CrimeDepartmentPage.empty() =>
      const CrimeDepartmentPage(totals: 0, items: []);

  factory CrimeDepartmentPage.fromJson(Map<String, dynamic> json) {
    return CrimeDepartmentPage(
      totals: _asInt(json['totals']),
      items: _asList(json['data']).map(CrimeDepartmentItem.fromJson).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Bundle (gộp tất cả)
// ---------------------------------------------------------------------------

class CrimeReportBundle {
  final WarningPage warnings;
  final TypeWarningPage types;
  final CrimeDepartmentPage departments;

  const CrimeReportBundle({
    required this.warnings,
    required this.types,
    required this.departments,
  });

  factory CrimeReportBundle.empty() {
    return CrimeReportBundle(
      warnings: WarningPage.empty(),
      types: TypeWarningPage.empty(),
      departments: CrimeDepartmentPage.empty(),
    );
  }
}

// ---------------------------------------------------------------------------
// Safe parsing helpers
// ---------------------------------------------------------------------------

int _asInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

double _asDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
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
