import '../../core/network/api_client.dart';
import '../models/booking_models.dart';
import '../models/dashboard_models.dart';
import '../models/work_calendar_models.dart';

/// Service cho Lịch công tác chung.
class WorkCalendarService extends ApiClient {
  WorkCalendarService() {
    onInit();
  }

  /// GET /booking/get-list — danh sách lịch công tác.
  Future<List<BookingModel>> getBookings({int page = 1, int limit = 200}) async {
    final body = await _getBody(
      '/booking/get-list',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return BookingListResponse.fromJson(body).data;
  }

  /// GET /room-booking/get-list-active — danh sách phòng họp.
  Future<List<MeetingRoomItem>> getRooms({int page = 1, int limit = 100}) async {
    final body = await _getBody(
      '/room-booking/get-list-active',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return MeetingRoomPage.fromJson(body).rooms;
  }

  /// GET /typebooking/get-list-active — loại lịch công tác.
  Future<List<TypeBookingItem>> getTypes({int page = 1, int limit = 100}) async {
    final body = await _getBody(
      '/typebooking/get-list-active',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return TypeBookingPage.fromJson(body).items;
  }

  Future<Map<String, dynamic>> _getBody(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    final response = await get(endpoint, query: query);
    if (response.isOk && response.body is Map) {
      return Map<String, dynamic>.from(response.body as Map);
    }
    throw Exception(response.statusText ?? 'Không thể tải lịch công tác');
  }
}
