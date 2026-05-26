import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/auth_helper.dart';
import '../../data/repositories/meeting_repository.dart';

/// Screen để test các API của Meeting/Booking.
/// Chỉ dùng cho development, xóa khi production.
class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final MeetingRepository _repository = MeetingRepository();
  final TextEditingController _tokenController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tokenController.text = AuthHelper.getToken() ?? '';
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _saveToken() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      _showResult('❌ Token không được để trống');
      return;
    }
    await AuthHelper.saveToken(token);
    _showResult('✅ Đã lưu token: $token');
  }

  Future<void> _testGetList() async {
    setState(() {
      _isLoading = true;
      _result = 'Đang gọi API...';
    });

    try {
      final bookings = await _repository.getBookingList(page: 1, limit: 10);

      if (bookings.isEmpty) {
        _showResult(
          '⚠️ GET /api/booking/get-list\n'
          'API trả về thành công nhưng danh sách rỗng.\n'
          'Kiểm tra:\n'
          '1. Token có đúng không?\n'
          '2. Có dữ liệu trên server không?\n'
          '3. Xem console log để biết chi tiết response',
        );
      } else {
        _showResult(
          '✅ GET /api/booking/get-list\n'
          'Số lượng: ${bookings.length}\n'
          'Dữ liệu:\n${bookings.map((b) => '- ${b.bookingTitle} (ID: ${b.bookingID})').join('\n')}',
        );
      }
    } catch (e, stackTrace) {
      _showResult('❌ Lỗi GET list:\n$e\n\nStack trace:\n$stackTrace');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testGetById() async {
    setState(() {
      _isLoading = true;
      _result = 'Đang gọi API...';
    });

    try {
      final booking = await _repository.getBookingById(4);
      if (booking != null) {
        _showResult(
          '✅ GET /api/booking/get-by-id?id=4\n'
          'Title: ${booking.bookingTitle}\n'
          'Start: ${booking.dateStart}\n'
          'End: ${booking.dateEnd}\n'
          'Location: Room ${booking.roomBookingID}\n'
          'Duration: ${booking.durationInMinutes} phút',
        );
      } else {
        _showResult('❌ Không tìm thấy booking ID=4');
      }
    } catch (e) {
      _showResult('❌ Lỗi GET by ID:\n$e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testCreate() async {
    setState(() {
      _isLoading = true;
      _result = 'Đang gọi API...';
    });

    try {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day, 14, 0);
      final end = start.add(const Duration(hours: 1));

      final booking = await _repository.createBooking(
        title: 'Test Meeting từ Flutter',
        dateStart: start,
        dateEnd: end,
        location: 'Phòng họp A',
        typeBookingID: 1,
        roomBookingID: 1,
        description: 'Test tạo lịch họp từ API',
      );

      if (booking != null) {
        _showResult(
          '✅ POST /api/booking/create\n'
          'BookingID: ${booking.bookingID}\n'
          'Title: ${booking.bookingTitle}\n'
          'Created: ${booking.dateCreated}',
        );
      } else {
        _showResult('❌ Tạo booking thất bại');
      }
    } catch (e) {
      _showResult('❌ Lỗi CREATE:\n$e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testDelete() async {
    setState(() {
      _isLoading = true;
      _result = 'Đang gọi API...';
    });

    try {
      // Test xóa booking ID=999 (giả định)
      final success = await _repository.deleteBooking(999);
      _showResult(
        success
            ? '✅ POST /api/booking/delete\nĐã xóa booking ID=999'
            : '❌ Xóa thất bại hoặc không tìm thấy ID=999',
      );
    } catch (e) {
      _showResult('❌ Lỗi DELETE:\n$e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showResult(String result) {
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test - Meeting/Booking'),
        backgroundColor: const Color(0xFF2F80ED),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Token input
            const Text(
              'Authorization Token',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                hintText: 'uid...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _saveToken,
              child: const Text('Lưu Token'),
            ),
            const SizedBox(height: 24),

            // Test buttons
            const Text(
              'Test API Endpoints',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testGetList,
              icon: const Icon(Icons.list),
              label: const Text('GET /api/booking/get-list'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testGetById,
              icon: const Icon(Icons.search),
              label: const Text('GET /api/booking/get-by-id?id=4'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testCreate,
              icon: const Icon(Icons.add),
              label: const Text('POST /api/booking/create'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testDelete,
              icon: const Icon(Icons.delete),
              label: const Text('POST /api/booking/delete (ID=999)'),
            ),
            const SizedBox(height: 24),

            // Result display
            const Text(
              'Kết quả',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              constraints: const BoxConstraints(minHeight: 200),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                      _result.isEmpty ? 'Chưa có kết quả' : _result,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
