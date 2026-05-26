import 'base_model.dart';

/// Model cho User tham gia cuộc họp.
class UserJoinModel extends BaseModel {
  final int userJoinID;
  final int bookingID;
  final int userID;
  final int statusID;
  final String dateCreated;
  final String dateUpdated;
  final String userCreated;
  final String userUpdated;

  const UserJoinModel({
    required this.userJoinID,
    required this.bookingID,
    required this.userID,
    required this.statusID,
    required this.dateCreated,
    required this.dateUpdated,
    required this.userCreated,
    required this.userUpdated,
  });

  factory UserJoinModel.fromJson(Map<String, dynamic> json) {
    return UserJoinModel(
      userJoinID: json['UserJoinID'] as int? ?? 0,
      bookingID: json['BookingID'] as int? ?? 0,
      userID: json['UserID'] as int? ?? 0,
      statusID: json['StatusID'] as int? ?? 0,
      dateCreated: json['DateCreated'] as String? ?? '',
      dateUpdated: json['DateUpdated'] as String? ?? '',
      userCreated: json['UserCreated'] as String? ?? '',
      userUpdated: json['UserUpdated'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'UserJoinID': userJoinID,
      'BookingID': bookingID,
      'UserID': userID,
      'StatusID': statusID,
      'DateCreated': dateCreated,
      'DateUpdated': dateUpdated,
      'UserCreated': userCreated,
      'UserUpdated': userUpdated,
    };
  }
}

/// Model cho file đính kèm cuộc họp.
class BookingAttachmentModel extends BaseModel {
  final int bookingAttachmentID;
  final int bookingID;
  final String filePath;
  final int statusID;
  final String dateCreated;
  final String dateUpdated;
  final String userCreated;
  final String userUpdated;

  const BookingAttachmentModel({
    required this.bookingAttachmentID,
    required this.bookingID,
    required this.filePath,
    required this.statusID,
    required this.dateCreated,
    required this.dateUpdated,
    required this.userCreated,
    required this.userUpdated,
  });

  factory BookingAttachmentModel.fromJson(Map<String, dynamic> json) {
    return BookingAttachmentModel(
      bookingAttachmentID: json['BookingAttachmentID'] as int? ?? 0,
      bookingID: json['BookingID'] as int? ?? 0,
      filePath: json['FilePath'] as String? ?? '',
      statusID: json['StatusID'] as int? ?? 0,
      dateCreated: json['DateCreated'] as String? ?? '',
      dateUpdated: json['DateUpdated'] as String? ?? '',
      userCreated: json['UserCreated'] as String? ?? '',
      userUpdated: json['UserUpdated'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'BookingAttachmentID': bookingAttachmentID,
      'BookingID': bookingID,
      'FilePath': filePath,
      'StatusID': statusID,
      'DateCreated': dateCreated,
      'DateUpdated': dateUpdated,
      'UserCreated': userCreated,
      'UserUpdated': userUpdated,
    };
  }
}

/// Model chính cho Booking (Lịch họp).
class BookingModel extends BaseModel {
  final int bookingID;
  final int formID;
  final String typeBookingName;
  final int typeBookingID;
  final int roomBookingID;
  final int userIDInvite;
  final String bookingTitle;
  final String dateStart;
  final String dateEnd;
  final int statusID;
  final String description;
  final String dateCreated;
  final String dateUpdated;
  final String userCreated;
  final String userUpdated;
  final List<UserJoinModel> lstUserJoin;
  final List<BookingAttachmentModel> lstBookingAttachment;

  const BookingModel({
    required this.bookingID,
    required this.formID,
    required this.typeBookingName,
    required this.typeBookingID,
    required this.roomBookingID,
    required this.userIDInvite,
    required this.bookingTitle,
    required this.dateStart,
    required this.dateEnd,
    required this.statusID,
    required this.description,
    required this.dateCreated,
    required this.dateUpdated,
    required this.userCreated,
    required this.userUpdated,
    this.lstUserJoin = const [],
    this.lstBookingAttachment = const [],
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingID: json['BookingID'] as int? ?? 0,
      formID: json['FormID'] as int? ?? 0,
      typeBookingName: json['TypeBookingName'] as String? ?? '',
      typeBookingID: json['TypeBookingID'] as int? ?? 0,
      roomBookingID: json['RoomBookingID'] as int? ?? 0,
      userIDInvite: json['UserID_Invite'] as int? ?? 0,
      bookingTitle: json['BookingTitle'] as String? ?? '',
      dateStart: json['DateStart'] as String? ?? '',
      dateEnd: json['DateEnd'] as String? ?? '',
      statusID: json['StatusID'] as int? ?? 0,
      description: json['Description'] as String? ?? '',
      dateCreated: json['DateCreated'] as String? ?? '',
      dateUpdated: json['DateUpdated'] as String? ?? '',
      userCreated: json['UserCreated'] as String? ?? '',
      userUpdated: json['UserUpdated'] as String? ?? '',
      lstUserJoin: (json['lstUserJoin'] as List<dynamic>?)
              ?.map((e) => UserJoinModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lstBookingAttachment: (json['lstBookingAttachment'] as List<dynamic>?)
              ?.map((e) =>
                  BookingAttachmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'BookingID': bookingID,
      'FormID': formID,
      'TypeBookingName': typeBookingName,
      'TypeBookingID': typeBookingID,
      'RoomBookingID': roomBookingID,
      'UserID_Invite': userIDInvite,
      'BookingTitle': bookingTitle,
      'DateStart': dateStart,
      'DateEnd': dateEnd,
      'StatusID': statusID,
      'Description': description,
      'DateCreated': dateCreated,
      'DateUpdated': dateUpdated,
      'UserCreated': userCreated,
      'UserUpdated': userUpdated,
      'lstUserJoin': lstUserJoin.map((e) => e.toJson()).toList(),
      'lstBookingAttachment':
          lstBookingAttachment.map((e) => e.toJson()).toList(),
    };
  }

  /// Helper: Tính thời lượng cuộc họp (phút).
  int get durationInMinutes {
    try {
      final start = DateTime.parse(dateStart);
      final end = DateTime.parse(dateEnd);
      return end.difference(start).inMinutes;
    } catch (_) {
      return 0;
    }
  }

  /// Helper: Format thời gian bắt đầu (HH:mm).
  String get formattedStartTime {
    try {
      final dt = DateTime.parse(dateStart);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  /// Helper: Format ngày (dd/MM/yyyy).
  String get formattedDate {
    try {
      final dt = DateTime.parse(dateStart);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
}

/// Response wrapper cho danh sách booking.
class BookingListResponse {
  final int totals;
  final List<BookingModel> data;

  const BookingListResponse({
    required this.totals,
    required this.data,
  });

  factory BookingListResponse.fromJson(Map<String, dynamic> json) {
    return BookingListResponse(
      totals: json['totals'] as int? ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Response wrapper cho single booking.
class BookingDetailResponse {
  final BookingModel data;

  const BookingDetailResponse({required this.data});

  factory BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    return BookingDetailResponse(
      data: BookingModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
