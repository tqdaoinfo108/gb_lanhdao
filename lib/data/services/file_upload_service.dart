import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;

import '../../core/network/api_client.dart';
import '../../core/utils/auth_helper.dart';

/// Service dùng chung để upload file lên hệ thống.
class FileUploadService extends ApiClient {
  FileUploadService() {
    onInit();
  }

  /// Upload một file lên server.
  /// Trả về đường dẫn file trên server (thường nằm trong `data` field) nếu thành công,
  /// hoặc throw Exception nếu có lỗi.
  Future<String> uploadFile(File file) async {
    final token = AuthHelper.getToken();
    final userId = AuthHelper.getUserId()?.toString() ?? '1';
    final userName = AuthHelper.getUserName() ?? 'Administrator';
    final userTypeId = AuthHelper.getUserTypeId()?.toString() ?? '1';

    // Bỏ header Authorization tự động của ApiClient vì upload dùng custom headers.
    final headers = {
      'X-Skip-Authorization': 'true',
      'Token': token ?? '',
      'Userid': userId,
      'Username': userName,
      'Typeuserid': userTypeId,
      'Usertypeid': userTypeId,
      'Accept': 'application/json',
    };

    final fileName = p.basename(file.path);
    
    // Multipart form data
    final form = FormData({
      'file': MultipartFile(
        file,
        filename: fileName,
      ),
    });

    final response = await post(
      '/fileupload/upload',
      form,
      headers: headers,
    );

    if (response.isOk && response.body is Map) {
      final body = Map<String, dynamic>.from(response.body as Map);
      final data = body['data'];
      if (data is String && data.isNotEmpty) {
        return data;
      }
    }

    throw Exception(
      response.statusText ?? 'Không thể tải lên file: $fileName',
    );
  }
}
