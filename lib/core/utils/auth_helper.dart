import 'package:get_storage/get_storage.dart';

/// Helper class để quản lý authentication token.
class AuthHelper {
  static final _storage = GetStorage();
  static const String _tokenKey = 'access_token';

  /// Lưu token vào storage.
  static Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  /// Lấy token từ storage.
  static String? getToken() {
    return _storage.read(_tokenKey);
  }

  /// Xóa token khỏi storage.
  static Future<void> clearToken() async {
    await _storage.remove(_tokenKey);
  }

  /// Kiểm tra xem đã có token chưa.
  static bool hasToken() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  /// Set token mẫu cho testing (tạm thời).
  /// TODO: Xóa method này khi có màn hình login thực tế.
  static Future<void> setMockToken() async {
    // Format: uid... (không có "Bearer")
    await saveToken('uid_mock_token_for_testing');
  }
}
