import 'booking_models.dart';

class DashboardSummary {
  final int totalProcessUndone;
  final int totalProcessUndoneLastWeek;
  final int totalProcessPriority;
  final double percentCompleteKpi;
  final double percentCompleteKpiLast;
  final int totalKpi;
  final int totalKpiDone;
  final int totalBooking;
  final int totalBookingToday;
  final int totalBookingLast;
  final String nextBooking;
  final int totalHouseHold;
  final int totalHouseHoldIn;
  final int totalHouseHoldOut;
  final int totalHouseHoldLast;

  const DashboardSummary({
    required this.totalProcessUndone,
    required this.totalProcessUndoneLastWeek,
    required this.totalProcessPriority,
    required this.percentCompleteKpi,
    required this.percentCompleteKpiLast,
    required this.totalKpi,
    required this.totalKpiDone,
    required this.totalBooking,
    required this.totalBookingToday,
    required this.totalBookingLast,
    required this.nextBooking,
    required this.totalHouseHold,
    required this.totalHouseHoldIn,
    required this.totalHouseHoldOut,
    required this.totalHouseHoldLast,
  });

  factory DashboardSummary.empty() {
    return const DashboardSummary(
      totalProcessUndone: 0,
      totalProcessUndoneLastWeek: 0,
      totalProcessPriority: 0,
      percentCompleteKpi: 0,
      percentCompleteKpiLast: 0,
      totalKpi: 0,
      totalKpiDone: 0,
      totalBooking: 0,
      totalBookingToday: 0,
      totalBookingLast: 0,
      nextBooking: 'Không có dữ liệu lịch họp',
      totalHouseHold: 0,
      totalHouseHoldIn: 0,
      totalHouseHoldOut: 0,
      totalHouseHoldLast: 0,
    );
  }

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalProcessUndone: _asInt(json['TotalProcessUndone']),
      totalProcessUndoneLastWeek: _asInt(json['TotalProcessUndoneLastWeek']),
      totalProcessPriority: _asInt(json['TotalProcessPriority']),
      percentCompleteKpi: _asDouble(json['PercentCompleteKPI']),
      percentCompleteKpiLast: _asDouble(json['PercentCompleteKPILast']),
      totalKpi: _asInt(json['TotalKPI']),
      totalKpiDone: _asInt(json['TotalKPIDone']),
      totalBooking: _asInt(json['TotalBooking']),
      totalBookingToday: _asInt(json['TotalBookingToday']),
      totalBookingLast: _asInt(json['TotalBookingLast']),
      nextBooking: (json['NextBooking'] as String?)?.trim().isNotEmpty == true
          ? (json['NextBooking'] as String).trim()
          : 'Không có cuộc họp nào sắp tới',
      totalHouseHold: _asInt(json['TotalHouseHold']),
      totalHouseHoldIn: _asInt(json['TotalHouseHoldIn']),
      totalHouseHoldOut: _asInt(json['TotalHouseHoldOut']),
      totalHouseHoldLast: _asInt(json['TotalHouseHoldLast']),
    );
  }
}

class DashboardTrendPoint {
  final String label;
  final double kpiPercent;
  final double processPercent;
  final DateTime? fromDate;
  final DateTime? toDate;

  const DashboardTrendPoint({
    required this.label,
    required this.kpiPercent,
    required this.processPercent,
    this.fromDate,
    this.toDate,
  });

  factory DashboardTrendPoint.fromJson(Map<String, dynamic> json) {
    return DashboardTrendPoint(
      label: json['Label'] as String? ?? '',
      kpiPercent: _asDouble(json['KPIPercent']),
      processPercent: _asDouble(json['ProcessPercent']),
      fromDate: _asDate(json['FromDate']),
      toDate: _asDate(json['ToDate']),
    );
  }
}

class DepartmentWorkload {
  final int departmentId;
  final String departmentName;
  final int totalCompleted;
  final int totalProcessing;
  final int totalPending;
  final int totalOverdue;

  const DepartmentWorkload({
    required this.departmentId,
    required this.departmentName,
    required this.totalCompleted,
    required this.totalProcessing,
    required this.totalPending,
    required this.totalOverdue,
  });

  int get total =>
      totalCompleted + totalProcessing + totalPending + totalOverdue;

  factory DepartmentWorkload.fromJson(Map<String, dynamic> json) {
    return DepartmentWorkload(
      departmentId: _asInt(json['DepartmentID']),
      departmentName: json['DepartmentName'] as String? ?? 'Chưa xác định',
      totalCompleted: _asInt(json['TotalCompleted']),
      totalProcessing: _asInt(json['TotalProcessing']),
      totalPending: _asInt(json['TotalPending']),
      totalOverdue: _asInt(json['TotalOverdue']),
    );
  }
}

class DashboardKpiItem {
  final int kpiId;
  final String kpiName;
  final String departmentName;
  final String userProcessName;
  final double progress;
  final DateTime? dateExpired;
  final int statusId;
  final String statusName;

  const DashboardKpiItem({
    required this.kpiId,
    required this.kpiName,
    required this.departmentName,
    required this.userProcessName,
    required this.progress,
    this.dateExpired,
    required this.statusId,
    required this.statusName,
  });

  factory DashboardKpiItem.fromJson(Map<String, dynamic> json) {
    return DashboardKpiItem(
      kpiId: _asInt(json['KPIID']),
      kpiName: json['KPIName'] as String? ?? 'Chưa đặt tên KPI',
      departmentName: json['DepartmentName'] as String? ?? 'Chưa xác định',
      userProcessName: json['UserProcessName'] as String? ?? 'Chưa xác định',
      progress: _asDouble(json['Progress']),
      dateExpired: _asDate(json['DateExpired']),
      statusId: _asInt(json['StatusID']),
      statusName: json['StatusName'] as String? ?? 'Chưa xác định',
    );
  }
}

class DashboardUser {
  final int userId;
  final String fullName;
  final String userName;
  final String positionName;
  final String departmentName;
  final String phone;
  final String email;
  final String statusName;
  final String imagePath;

  const DashboardUser({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.positionName,
    required this.departmentName,
    required this.phone,
    required this.email,
    required this.statusName,
    required this.imagePath,
  });

  String get initials {
    final source = fullName.trim().isNotEmpty ? fullName.trim() : userName;
    if (source.isEmpty) return 'U';
    final parts = source.split(RegExp(r'\s+'));
    if (parts.length == 1) return _takeRunes(parts.first, 2).toUpperCase();
    return '${_takeRunes(parts.first, 1)}${_takeRunes(parts.last, 1)}'
        .toUpperCase();
  }

  factory DashboardUser.fromJson(Map<String, dynamic> json) {
    return DashboardUser(
      userId: _asInt(json['UserID']),
      fullName: json['FullName'] as String? ?? '',
      userName: json['UserName'] as String? ?? '',
      positionName: json['PositionName'] as String? ?? '',
      departmentName: json['DepartmentName'] as String? ?? 'Chưa xác định',
      phone: json['Phone'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      statusName: json['StatusName'] as String? ?? '',
      imagePath: json['ImagePath'] as String? ?? '',
    );
  }
}

class DashboardUserPage {
  final int totals;
  final List<DashboardUser> users;

  const DashboardUserPage({required this.totals, required this.users});

  factory DashboardUserPage.empty() {
    return const DashboardUserPage(totals: 0, users: []);
  }

  factory DashboardUserPage.fromJson(Map<String, dynamic> json) {
    return DashboardUserPage(
      totals: _asInt(json['totals']),
      users: _asList(
        json['data'],
      ).map((item) => DashboardUser.fromJson(item)).toList(),
    );
  }
}

class DashboardBundle {
  final DashboardSummary summary;
  final List<DashboardTrendPoint> trends;
  final List<DepartmentWorkload> departments;
  final List<DashboardKpiItem> kpis;
  final DashboardUserPage activeUsers;

  const DashboardBundle({
    required this.summary,
    required this.trends,
    required this.departments,
    required this.kpis,
    required this.activeUsers,
  });

  factory DashboardBundle.empty() {
    return DashboardBundle(
      summary: DashboardSummary.empty(),
      trends: const [],
      departments: const [],
      kpis: const [],
      activeUsers: DashboardUserPage.empty(),
    );
  }
}

class PeriodReportItem {
  final String title;
  final int sumProcessDetail;
  final int sumDocumentDetail;
  final double sumBookingDetail;

  const PeriodReportItem({
    required this.title,
    required this.sumProcessDetail,
    required this.sumDocumentDetail,
    required this.sumBookingDetail,
  });

  factory PeriodReportItem.fromJson(Map<String, dynamic> json) {
    return PeriodReportItem(
      title: json['Title'] as String? ?? '',
      sumProcessDetail: _asInt(json['SumProcessDetail']),
      sumDocumentDetail: _asInt(json['SumDocumentDetail']),
      sumBookingDetail: _asDouble(json['SumBookingDetail']),
    );
  }
}

class PeriodReportSummary {
  final int totalCurProcess;
  final int totalPrevProcess;
  final double percentProcess;
  final int totalCurDocument;
  final int totalPrevDocument;
  final double percentDocument;
  final int totalCurBooking;
  final int totalPrevBooking;
  final double percentBooking;
  final double totalPercKpi;
  final double prevPercKpi;
  final List<PeriodReportItem> items;

  const PeriodReportSummary({
    required this.totalCurProcess,
    required this.totalPrevProcess,
    required this.percentProcess,
    required this.totalCurDocument,
    required this.totalPrevDocument,
    required this.percentDocument,
    required this.totalCurBooking,
    required this.totalPrevBooking,
    required this.percentBooking,
    required this.totalPercKpi,
    required this.prevPercKpi,
    required this.items,
  });

  factory PeriodReportSummary.empty() {
    return const PeriodReportSummary(
      totalCurProcess: 0,
      totalPrevProcess: 0,
      percentProcess: 0,
      totalCurDocument: 0,
      totalPrevDocument: 0,
      percentDocument: 0,
      totalCurBooking: 0,
      totalPrevBooking: 0,
      percentBooking: 0,
      totalPercKpi: 0,
      prevPercKpi: 0,
      items: [],
    );
  }

  factory PeriodReportSummary.fromJson(Map<String, dynamic> json) {
    return PeriodReportSummary(
      totalCurProcess: _asInt(json['Total_CurProcess']),
      totalPrevProcess: _asInt(json['Total_PrevProcess']),
      percentProcess: _asDouble(json['PhanTram_Process']),
      totalCurDocument: _asInt(json['Total_CurDocument']),
      totalPrevDocument: _asInt(json['Total_PrevDocument']),
      percentDocument: _asDouble(json['PhanTram_Document']),
      totalCurBooking: _asInt(json['Total_CurBooking']),
      totalPrevBooking: _asInt(json['Total_PrevBooking']),
      percentBooking: _asDouble(json['PhanTram_Booking']),
      totalPercKpi: _asDouble(json['Total_PercKPI']),
      prevPercKpi: _asDouble(json['Prev_PercKPI']),
      items: _asList(json['lstItem'])
          .map((item) => PeriodReportItem.fromJson(item))
          .toList(),
    );
  }
}

class PeriodTrendPoint {
  final String title;
  final double percKpi;
  final int totalProcessExpired;
  final int totalDocument;

  const PeriodTrendPoint({
    required this.title,
    required this.percKpi,
    required this.totalProcessExpired,
    required this.totalDocument,
  });

  factory PeriodTrendPoint.fromJson(Map<String, dynamic> json) {
    return PeriodTrendPoint(
      title: json['Title'] as String? ?? '',
      percKpi: _asDouble(json['PercKPI']),
      totalProcessExpired: _asInt(json['totalProcessExpired']),
      totalDocument: _asInt(json['totalDocument']),
    );
  }
}

class DashboardNotificationItem {
  final int notificationId;
  final int typeId;
  final int id;
  final int userId;
  final String title;
  final String message;
  final int statusId;
  final bool isAll;
  final DateTime? dateCreated;
  final DateTime? dateUpdated;
  final String userCreated;
  final String userUpdated;
  final String timeAgo;

  const DashboardNotificationItem({
    required this.notificationId,
    required this.typeId,
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.statusId,
    required this.isAll,
    required this.dateCreated,
    required this.dateUpdated,
    required this.userCreated,
    required this.userUpdated,
    required this.timeAgo,
  });

  String get plainTitle => _stripHtml(title).trim().isNotEmpty
      ? _stripHtml(title).trim()
      : title.trim();

  factory DashboardNotificationItem.fromJson(Map<String, dynamic> json) {
    return DashboardNotificationItem(
      notificationId: _asInt(json['NotificationID']),
      typeId: _asInt(json['TypeID']),
      id: _asInt(json['ID']),
      userId: _asInt(json['UserID']),
      title: json['Title'] as String? ?? '',
      message: json['Message'] as String? ?? '',
      statusId: _asInt(json['StatusID']),
      isAll: json['IsAll'] as bool? ?? false,
      dateCreated: _asDate(json['DateCreated']),
      dateUpdated: _asDate(json['DateUpdated']),
      userCreated: json['UserCreated'] as String? ?? '',
      userUpdated: json['UserUpdated'] as String? ?? '',
      timeAgo: json['TimeAgo'] as String? ?? '',
    );
  }
}

class DashboardNotificationPage {
  final int totals;
  final List<DashboardNotificationItem> items;

  const DashboardNotificationPage({required this.totals, required this.items});

  factory DashboardNotificationPage.empty() {
    return const DashboardNotificationPage(totals: 0, items: []);
  }

  factory DashboardNotificationPage.fromJson(Map<String, dynamic> json) {
    return DashboardNotificationPage(
      totals: _asInt(json['totals']),
      items: _asList(json['data'])
          .map((item) => DashboardNotificationItem.fromJson(item))
          .toList(),
    );
  }
}

class PeriodicReportBundle {
  final PeriodReportSummary summary;
  final List<PeriodTrendPoint> trends;
  final DashboardNotificationPage notifications;

  const PeriodicReportBundle({
    required this.summary,
    required this.trends,
    required this.notifications,
  });

  factory PeriodicReportBundle.empty() {
    return PeriodicReportBundle(
      summary: PeriodReportSummary.empty(),
      trends: const [],
      notifications: DashboardNotificationPage.empty(),
    );
  }
}

class MeetingRoomItem {
  final int roomBookingId;
  final int typeRoomId;
  final String roomBookingName;
  final int statusId;
  final String description;
  final String dateCreated;
  final String dateUpdated;
  final String userCreated;
  final String userUpdated;

  const MeetingRoomItem({
    required this.roomBookingId,
    required this.typeRoomId,
    required this.roomBookingName,
    required this.statusId,
    required this.description,
    required this.dateCreated,
    required this.dateUpdated,
    required this.userCreated,
    required this.userUpdated,
  });

  factory MeetingRoomItem.fromJson(Map<String, dynamic> json) {
    return MeetingRoomItem(
      roomBookingId: _asInt(json['RoomBookingID']),
      typeRoomId: _asInt(json['TypeRoomID']),
      roomBookingName: json['RoomBookingName'] as String? ?? '',
      statusId: _asInt(json['StatusID']),
      description: json['Description'] as String? ?? '',
      dateCreated: json['DateCreated'] as String? ?? '',
      dateUpdated: json['DateUpdated'] as String? ?? '',
      userCreated: json['UserCreated'] as String? ?? '',
      userUpdated: json['UserUpdated'] as String? ?? '',
    );
  }
}

class MeetingRoomPage {
  final int totals;
  final List<MeetingRoomItem> rooms;

  const MeetingRoomPage({required this.totals, required this.rooms});

  factory MeetingRoomPage.empty() {
    return const MeetingRoomPage(totals: 0, rooms: []);
  }

  factory MeetingRoomPage.fromJson(Map<String, dynamic> json) {
    return MeetingRoomPage(
      totals: _asInt(json['totals']),
      rooms: _asList(json['data'])
          .map((item) => MeetingRoomItem.fromJson(item))
          .toList(),
    );
  }
}

class TodayBookingPage {
  final int totalBookingMonth;
  final List<BookingModel> bookings;

  const TodayBookingPage({
    required this.totalBookingMonth,
    required this.bookings,
  });

  factory TodayBookingPage.empty() {
    return const TodayBookingPage(totalBookingMonth: 0, bookings: []);
  }

  factory TodayBookingPage.fromJson(Map<String, dynamic> json) {
    return TodayBookingPage(
      totalBookingMonth: _asInt(json['TotalBookingMonth']),
      bookings: _asList(json['lstBooking'])
          .map((item) => BookingModel.fromJson(item))
          .toList(),
    );
  }
}

class MeetingHubBundle {
  final DashboardUserPage activeUsers;
  final MeetingRoomPage rooms;
  final TodayBookingPage todayBookings;

  const MeetingHubBundle({
    required this.activeUsers,
    required this.rooms,
    required this.todayBookings,
  });

  factory MeetingHubBundle.empty() {
    return MeetingHubBundle(
      activeUsers: DashboardUserPage.empty(),
      rooms: MeetingRoomPage.empty(),
      todayBookings: TodayBookingPage.empty(),
    );
  }
}

class KpiSummary {
  final String title;
  final String value;
  final String unit;
  final String description;
  final String? trend;
  final bool isTrendPositive;
  final KpiIconType iconType;

  const KpiSummary({
    required this.title,
    required this.value,
    this.unit = '',
    required this.description,
    this.trend,
    this.isTrendPositive = true,
    required this.iconType,
  });
}

enum KpiIconType { project, staff, meeting, resident }

class MeetingItem {
  final String time;
  final String title;
  final String location;
  final String? tag;
  final bool isUrgent;

  const MeetingItem({
    required this.time,
    required this.title,
    required this.location,
    this.tag,
    this.isUrgent = false,
  });
}

class AlertInfo {
  final int count;
  final String label;
  final String description;

  const AlertInfo({
    required this.count,
    required this.label,
    required this.description,
  });
}

class AiInsight {
  final String content;
  final String actionLabel;

  const AiInsight({required this.content, required this.actionLabel});
}

class ChartDataPoint {
  final String label;
  final double value;

  const ChartDataPoint({required this.label, required this.value});
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

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

String _takeRunes(String value, int count) {
  return String.fromCharCodes(value.runes.take(count));
}

String _stripHtml(String value) {
  return value.replaceAll(RegExp(r'<[^>]*>'), ' ');
}
