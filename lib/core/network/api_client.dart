import 'package:get/get.dart';
import '../utils/auth_helper.dart';

/// Base API Client dùng GetConnect.
/// Mọi Service đều kế thừa class này.
class ApiClient extends GetConnect {
  static const String _baseUrl = 'http://apigiongtrom.gvbsoft.com/api';
  static const String _skipAuthHeader = 'X-Skip-Authorization';

  @override
  void onInit() {
    httpClient.baseUrl = _baseUrl;
    httpClient.timeout = const Duration(seconds: 30);

    // Gắn token tự động vào mọi request
    httpClient.addRequestModifier<dynamic>((request) async {
      final skipAuth = request.headers.remove(_skipAuthHeader) == 'true';
      final token = AuthHelper.getToken();
      if (!skipAuth && token != null) {
        // API yêu cầu format: Authorization: uid... (không có "Bearer")
        request.headers['Authorization'] = token;
      }
      // GetConnect tự đặt multipart/form-data (kèm boundary) cho FormData.
      // Chỉ thêm JSON khi request chưa có content type để không ghi đè multipart.
      if (!request.headers.containsKey('content-type')) {
        request.headers.putIfAbsent('content-type', () => 'application/json');
      }
      request.headers.putIfAbsent('accept', () => 'application/json');
      return request;
    });

    // Log response lỗi (chỉ debug)
    httpClient.addResponseModifier((request, response) async {
      if (!response.isOk) {
        // ignore: avoid_print
        print(
          '[API ERROR] ${request.method} ${request.url} → ${response.statusCode}',
        );
        // ignore: avoid_print
        print('[API ERROR BODY] ${response.bodyString}');
      }
      return response;
    });

    super.onInit();
  }
}
