import '../models/booking_models.dart';
import '../models/meeting_schedule_models.dart';
import '../services/meeting_service.dart';

/// Repository xử lý business logic cho Meeting/Booking.
/// Cầu nối giữa Service và Controller.
class MeetingRepository {
  final MeetingService _service = MeetingService();

  // ---------------------------------------------------------------------------
  // Lấy danh sách lịch họp
  // ---------------------------------------------------------------------------
  Future<List<BookingModel>> getBookingList({
    int page = 1,
    int limit = 100,
  }) async {
    try {
      // ignore: avoid_print
      print('[MeetingRepository] Calling getBookingList...');

      final response = await _service.getList(page: page, limit: limit);

      // ignore: avoid_print
      print('[MeetingRepository] Response: $response');
      // ignore: avoid_print
      print('[MeetingRepository] Response data length: ${response?.data.length ?? 0}');

      return response?.data ?? [];
    } catch (e) {
      // ignore: avoid_print
      print('[MeetingRepository] getBookingList error: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Lấy chi tiết một lịch họp
  // ---------------------------------------------------------------------------
  Future<BookingModel?> getBookingById(int bookingId) async {
    try {
      return await _service.getById(bookingId);
    } catch (e) {
      // ignore: avoid_print
      print('[MeetingRepository] getBookingById error: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Tạo lịch họp mới
  // ---------------------------------------------------------------------------
  Future<BookingModel?> createBooking({
    required String title,
    required DateTime dateStart,
    required DateTime dateEnd,
    required String location,
    required int typeBookingID,
    required int roomBookingID,
    String description = '',
    int userIDInvite = 0,
  }) async {
    try {
      final bookingData = {
        'BookingTitle': title,
        'DateStart': dateStart.toIso8601String(),
        'DateEnd': dateEnd.toIso8601String(),
        'Description': description,
        'TypeBookingID': typeBookingID,
        'RoomBookingID': roomBookingID,
        'UserID_Invite': userIDInvite,
        'StatusID': 1,
      };

      return await _service.create(bookingData);
    } catch (e) {
      // ignore: avoid_print
      print('[MeetingRepository] createBooking error: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Cập nhật lịch họp
  // ---------------------------------------------------------------------------
  Future<BookingModel?> updateBooking(BookingModel booking) async {
    try {
      return await _service.update(booking.toJson());
    } catch (e) {
      // ignore: avoid_print
      print('[MeetingRepository] updateBooking error: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Xóa lịch họp
  // ---------------------------------------------------------------------------
  Future<bool> deleteBooking(int bookingId) async {
    try {
      return await _service.deleteBooking(bookingId);
    } catch (e) {
      // ignore: avoid_print
      print('[MeetingRepository] deleteBooking error: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Transform: BookingModel → MeetingScheduleSection (cho UI)
  // ---------------------------------------------------------------------------
  List<MeetingScheduleSection> transformToSections(
    List<BookingModel> bookings,
  ) {
    if (bookings.isEmpty) return [];

    // Group theo ngày
    final Map<String, List<BookingModel>> groupedByDate = {};

    for (final booking in bookings) {
      try {
        final date = DateTime.parse(booking.dateStart);
        final sectionTitle = _buildSectionTitle(date);

        if (!groupedByDate.containsKey(sectionTitle)) {
          groupedByDate[sectionTitle] = [];
        }
        groupedByDate[sectionTitle]!.add(booking);
      } catch (_) {
        // Skip invalid dates
      }
    }

    // Convert sang MeetingScheduleSection
    final sections = <MeetingScheduleSection>[];

    groupedByDate.forEach((title, bookingList) {
      // Sort theo thời gian
      bookingList.sort((a, b) {
        try {
          return DateTime.parse(a.dateStart)
              .compareTo(DateTime.parse(b.dateStart));
        } catch (_) {
          return 0;
        }
      });

      final meetings = bookingList.map((booking) {
        return MeetingScheduleItem(
          time: booking.formattedStartTime,
          title: booking.bookingTitle,
          location: _getRoomName(booking.roomBookingID),
          duration: '${booking.durationInMinutes} phút',
          platform: booking.typeBookingName,
          attendeeSummary: booking.lstUserJoin.isNotEmpty
              ? '${booking.lstUserJoin.length} người'
              : null,
          organizer: booking.userCreated,
          statusLabel: _getStatusLabel(booking.statusID),
          isHighlighted: booking.statusID == 1,
        );
      }).toList();

      final isToday = title == 'HÔM NAY';
      sections.add(
        MeetingScheduleSection(
          title: title,
          subtitle: isToday ? '${meetings.length} cuộc họp' : '',
          meetings: meetings,
        ),
      );
    });

    return sections;
  }

  // ---------------------------------------------------------------------------
  // Private Helpers
  // ---------------------------------------------------------------------------
  String _buildSectionTitle(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    if (_isSameDate(date, today)) {
      return 'HÔM NAY';
    }
    if (_isSameDate(date, tomorrow)) {
      return 'NGÀY MAI, ${_dd(date.day)} THÁNG ${_dd(date.month)}';
    }
    return 'NGÀY ${_dd(date.day)} THÁNG ${_dd(date.month)}, ${date.year}';
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _dd(int n) => n.toString().padLeft(2, '0');

  String _getRoomName(int roomId) {
    // TODO: Map room ID to room name (có thể lấy từ API khác)
    final roomMap = {
      1: 'Phòng họp A',
      2: 'Phòng họp B',
      3: 'Phòng họp C',
    };
    return roomMap[roomId] ?? 'Phòng họp $roomId';
  }

  String _getStatusLabel(int statusId) {
    final statusMap = {
      1: 'MỚI',
      2: 'ĐÃ XÁC NHẬN',
      3: 'ĐANG DIỄN RA',
      4: 'ĐÃ KẾT THÚC',
      5: 'ĐÃ HỦY',
    };
    return statusMap[statusId] ?? '';
  }
}
