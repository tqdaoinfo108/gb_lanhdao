import 'package:get_storage/get_storage.dart';

import '../values/app_constants.dart';

/// Helper qu?n l? authentication token.
class AuthHelper {
  static final _storage = GetStorage();
  static const String _tokenKey = AppConstants.keyToken;
  static const String _userIdKey = AppConstants.keyUserId;
  static const String _userNameKey = AppConstants.keyUserName;
  static const String _userTypeIdKey = AppConstants.keyUserTypeId;

  /// Lưu token vào storage.
  static Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  /// Lấy token từ storage.
  static String? getToken() {
    return _storage.read(_tokenKey);
  }

  /// Lưu thông tin user (để gửi kèm header upload).
  static Future<void> saveUserInfo(int userId, String userName, int userTypeId) async {
    await _storage.write(_userIdKey, userId);
    await _storage.write(_userNameKey, userName);
    await _storage.write(_userTypeIdKey, userTypeId);
  }

  static int? getUserId() => _storage.read<int>(_userIdKey);
  static String? getUserName() => _storage.read<String>(_userNameKey);
  static int? getUserTypeId() => _storage.read<int>(_userTypeIdKey);

  /// Xóa token và user info khỏi storage.
  static Future<void> clearToken() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_userIdKey);
    await _storage.remove(_userNameKey);
    await _storage.remove(_userTypeIdKey);
  }

  /// Kiểm tra xem đã có token chưa.
  static bool hasToken() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
}
