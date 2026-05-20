import 'package:get/get.dart';
import '../../../data/models/meeting_schedule_models.dart';
import '../../../data/models/booking_models.dart';
import '../../../data/repositories/meeting_repository.dart';

/// Controller cho màn hình lịch họp.
class MeetingScheduleController extends GetxController {
  final MeetingRepository _repository = MeetingRepository();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<MeetingScheduleSection> sections = <MeetingScheduleSection>[].obs;
  final RxList<BookingModel> bookings = <BookingModel>[].obs;

  String get headerTitle => 'Lịch họp sắp tới';
  String get headerDate {
    final now = DateTime.now();
    final weekdays = [
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
      'Chủ Nhật'
    ];
    final weekday = weekdays[now.weekday - 1];
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    return '$weekday, $day Tháng $month, ${now.year}';
  }

  List<String> get locationOptions => [
        'Phòng họp A',
        'Phòng họp B',
        'Phòng họp C',
        'Phòng họp D',
      ];

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Gọi API lấy danh sách booking
      final bookingList = await _repository.getBookingList(page: 1, limit: 100);
      bookings.assignAll(bookingList);

      // Transform sang sections cho UI
      final transformedSections = _repository.transformToSections(bookingList);
      sections.assignAll(transformedSections);
    } catch (e) {
      errorMessage.value = 'Không thể tải dữ liệu: ${e.toString()}';
      // ignore: avoid_print
      print('[MeetingScheduleController] loadData error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMeeting({
    required DateTime date,
    required String time,
    required String title,
    required String location,
    required String duration,
    String? organizer,
    String statusLabel = 'MỚI',
  }) async {
    try {
      // Parse time và duration
      final timeParts = time.split(':');
      final hour = int.tryParse(timeParts[0]) ?? 8;
      final minute = timeParts.length > 1 ? int.tryParse(timeParts[1]) ?? 0 : 0;

      final durationMinutes = int.tryParse(duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 60;

      // Tạo DateTime cho start và end
      final dateStart = DateTime(date.year, date.month, date.day, hour, minute);
      final dateEnd = dateStart.add(Duration(minutes: durationMinutes));

      // Map location sang roomBookingID
      final roomId = _getRoomIdFromLocation(location);

      // Gọi API tạo booking
      final newBooking = await _repository.createBooking(
        title: title,
        dateStart: dateStart,
        dateEnd: dateEnd,
        location: location,
        typeBookingID: 1, // Default: Cuộc họp
        roomBookingID: roomId,
        description: '',
      );

      if (newBooking != null) {
        // Reload data để cập nhật UI
        await loadData();
      }
    } catch (e) {
      errorMessage.value = 'Không thể tạo lịch họp: ${e.toString()}';
      // ignore: avoid_print
      print('[MeetingScheduleController] addMeeting error: $e');
      rethrow;
    }
  }

  Future<void> deleteMeeting({
    required String sectionTitle,
    required int meetingIndex,
  }) async {
    try {
      // Tìm booking tương ứng
      final sectionIndex = sections.indexWhere((s) => s.title == sectionTitle);
      if (sectionIndex == -1) return;

      final section = sections[sectionIndex];
      if (meetingIndex < 0 || meetingIndex >= section.meetings.length) return;

      // Tìm bookingID từ danh sách bookings
      // (Cần match theo title và time)
      final meetingToDelete = section.meetings[meetingIndex];
      final booking = bookings.firstWhereOrNull(
        (b) => b.bookingTitle == meetingToDelete.title &&
               b.formattedStartTime == meetingToDelete.time,
      );

      if (booking == null) {
        errorMessage.value = 'Không tìm thấy lịch họp để xóa';
        return;
      }

      // Gọi API xóa
      final success = await _repository.deleteBooking(booking.bookingID);

      if (success) {
        // Reload data để cập nhật UI
        await loadData();
      } else {
        errorMessage.value = 'Không thể xóa lịch họp';
      }
    } catch (e) {
      errorMessage.value = 'Lỗi khi xóa lịch họp: ${e.toString()}';
      // ignore: avoid_print
      print('[MeetingScheduleController] deleteMeeting error: $e');
      rethrow;
    }
  }

  int _getRoomIdFromLocation(String location) {
    if (location.contains('A')) return 1;
    if (location.contains('B')) return 2;
    if (location.contains('C')) return 3;
    if (location.contains('D')) return 4;
    return 1; // Default
  }
}
