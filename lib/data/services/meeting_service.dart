import '../../core/network/api_client.dart';
import '../models/booking_models.dart';

/// Service xử lý các API calls liên quan đến Booking/Meeting.
class MeetingService extends ApiClient {
  MeetingService() {
    onInit(); // Khởi tạo base URL và interceptors
  }

  // ---------------------------------------------------------------------------
  // GET: Lấy danh sách lịch họp
  // ---------------------------------------------------------------------------
  /// GET /api/booking/get-list?page=1&limit=20
  Future<BookingListResponse?> getList({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await get(
        '/booking/get-list',
        query: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      // ignore: avoid_print
      print('[MeetingService] getList response status: ${response.statusCode}');
      // ignore: avoid_print
      print('[MeetingService] getList response body: ${response.body}');

      if (response.isOk && response.body != null) {
        final body = response.body;

        // API trả về trực tiếp object {totals, data}, không wrap trong "data"
        if (body is Map<String, dynamic>) {
          return BookingListResponse.fromJson(body);
        }
      }

      return null;
    } catch (e) {
      // ignore: avoid_print
      print('[MeetingService] getList error: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // GET: Lấy chi tiết một lịch họp
  // ---------------------------------------------------------------------------
  /// GET /api/booking/get-by-id?bookingID=4
  Future<BookingModel?> getById(int bookingId) async {
    try {
      final response = await get(
        '/booking/get-by-id',
        query: {'bookingID': bookingId.toString()},
      );

      // ignore: avoid_print
      print('[MeetingService] getById response status: ${response.statusCode}');
      // ignore: avoid_print
      print('[MeetingService] getById response body: ${response.body}');

      if (response.isOk && response.body != null) {
        final detailResponse = BookingDetailResponse.fromJson(
          response.body as Map<String, dynamic>,
        );
        return detailResponse.data;
      }

      return null;
    } catch (e) {
      // ignore: avoid_print
      print('[MeetingService] getById error: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // POST: Tạo lịch họp mới
  // ---------------------------------------------------------------------------
  /// POST /api/booking/create
  Future<BookingModel?> create(Map<String, dynamic> bookingData) async {
    try {
      final response = await post('/booking/create', bookingData);

      if (response.isOk && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['data'] != null) {
          return BookingModel.fromJson(body['data'] as Map<String, dynamic>);
        }
      }

      return null;
    } catch (e) {
      // ignore: avoid_print
      print('[MeetingService] create error: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // POST: Cập nhật lịch họp
  // ---------------------------------------------------------------------------
  /// POST /api/booking/update
  Future<BookingModel?> update(Map<String, dynamic> bookingData) async {
    try {
      final response = await post('/booking/update', bookingData);

      if (response.isOk && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['data'] != null) {
          return BookingModel.fromJson(body['data'] as Map<String, dynamic>);
        }
      }

      return null;
    } catch (e) {
      // ignore: avoid_print
      print('[MeetingService] update error: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // POST: Xóa lịch họp
  // ---------------------------------------------------------------------------
  /// POST /api/booking/delete
  Future<bool> deleteBooking(int bookingId) async {
    try {
      final response = await post('/booking/delete', {'BookingID': bookingId});

      if (response.isOk && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        return body['data'] as bool? ?? false;
      }

      return false;
    } catch (e) {
      // ignore: avoid_print
      print('[MeetingService] deleteBooking error: $e');
      rethrow;
    }
  }
}
