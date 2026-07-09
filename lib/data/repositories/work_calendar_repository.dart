import '../models/booking_models.dart';
import '../models/dashboard_models.dart';
import '../models/work_calendar_models.dart';
import '../services/work_calendar_service.dart';

/// Repository cho Lịch công tác chung.
class WorkCalendarRepository {
  final WorkCalendarService _service;

  WorkCalendarRepository({WorkCalendarService? service})
    : _service = service ?? WorkCalendarService();

  Future<WorkCalendarBundle> getBundle() async {
    final results = await Future.wait<dynamic>([
      _service.getBookings(page: 1, limit: 200),
      _optional<List<MeetingRoomItem>>(() => _service.getRooms(), const []),
      _optional<List<TypeBookingItem>>(() => _service.getTypes(), const []),
    ]);

    return WorkCalendarBundle(
      bookings: results[0] as List<BookingModel>,
      rooms: results[1] as List<MeetingRoomItem>,
      types: results[2] as List<TypeBookingItem>,
    );
  }

  Future<T> _optional<T>(Future<T> Function() load, T fallback) async {
    try {
      return await load();
    } catch (_) {
      return fallback;
    }
  }
}
