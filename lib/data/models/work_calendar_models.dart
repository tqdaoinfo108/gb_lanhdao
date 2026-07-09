import 'booking_models.dart';
import 'dashboard_models.dart';

/// Loại lịch công tác (Cuộc họp, Nhiệm vụ, ...).
class TypeBookingItem {
  final int typeBookingId;
  final String typeBookingName;
  final int statusId;
  final String description;

  const TypeBookingItem({
    required this.typeBookingId,
    required this.typeBookingName,
    required this.statusId,
    required this.description,
  });

  factory TypeBookingItem.fromJson(Map<String, dynamic> json) {
    return TypeBookingItem(
      typeBookingId: _asInt(json['TypeBookingID']),
      typeBookingName: json['TypeBookingName'] as String? ?? 'Khác',
      statusId: _asInt(json['StatusID']),
      description: json['Description'] as String? ?? '',
    );
  }
}

class TypeBookingPage {
  final int totals;
  final List<TypeBookingItem> items;

  const TypeBookingPage({required this.totals, required this.items});

  factory TypeBookingPage.empty() {
    return const TypeBookingPage(totals: 0, items: []);
  }

  factory TypeBookingPage.fromJson(Map<String, dynamic> json) {
    return TypeBookingPage(
      totals: _asInt(json['totals']),
      items: _asList(json['data'])
          .map((item) => TypeBookingItem.fromJson(item))
          .toList(),
    );
  }
}

/// Gói dữ liệu cho màn Lịch công tác chung.
class WorkCalendarBundle {
  final List<BookingModel> bookings;
  final List<MeetingRoomItem> rooms;
  final List<TypeBookingItem> types;

  const WorkCalendarBundle({
    required this.bookings,
    required this.rooms,
    required this.types,
  });

  factory WorkCalendarBundle.empty() {
    return const WorkCalendarBundle(bookings: [], rooms: [], types: []);
  }

  bool get isEmpty => bookings.isEmpty && rooms.isEmpty && types.isEmpty;

  String roomName(int roomId) {
    for (final room in rooms) {
      if (room.roomBookingId == roomId) return room.roomBookingName;
    }
    return 'Phòng họp $roomId';
  }

  String typeName(int typeId, String fallback) {
    for (final type in types) {
      if (type.typeBookingId == typeId) return type.typeBookingName;
    }
    return fallback.isNotEmpty ? fallback : 'Khác';
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
