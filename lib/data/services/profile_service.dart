import '../../core/network/api_client.dart';
import '../models/user_profile_models.dart';

/// Service gọi API hồ sơ người dùng.
class ProfileService extends ApiClient {
  ProfileService() {
    onInit();
  }

  /// GET /user/profile — lấy thông tin người dùng đang đăng nhập.
  Future<UserProfile> getProfile() async {
    final response = await get('/user/profile');
    final data = _extractData(response, 'Không thể tải thông tin cá nhân');
    return UserProfile.fromJson(data);
  }

  /// POST /user/update-user — cập nhật thông tin người dùng.
  Future<UserProfile> updateUser(UserProfile profile) async {
    final response = await post('/user/update-user', profile.toJson());
    final data = _extractData(response, 'Không thể cập nhật thông tin cá nhân');
    return UserProfile.fromJson(data);
  }

  Map<String, dynamic> _extractData(dynamic response, String errorMessage) {
    if (response.isOk && response.body is Map) {
      final body = Map<String, dynamic>.from(response.body as Map);
      final data = body['data'];
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
    }
    throw Exception(response.statusText ?? errorMessage);
  }
}
