import 'package:get/get.dart';
import '../utils/auth_helper.dart';

/// Base API Client dùng GetConnect.
/// Mọi Service đều kế thừa class này.
class ApiClient extends GetConnect {
  static const String _baseUrl = 'https://apilanhdao.gvbsoft.vn/api';
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
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      return request;
    });   

    // Log response lỗi (chỉ debug)
    httpClient.addResponseModifier((request, response) async {
      if (!response.isOk) {
        // ignore: avoid_print
        print('[API ERROR] ${request.method} ${request.url} → ${response.statusCode}');
        // ignore: avoid_print
        print('[API ERROR BODY] ${response.bodyString}');
      }
      return response;
    });

    super.onInit();
  }
}
