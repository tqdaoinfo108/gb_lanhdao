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
    if (token == null || token.trim().isEmpty) {
      throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
    }

    // API upload yêu cầu chính token phiên đăng nhập trong Authorization.
    final headers = {
      'X-Skip-Authorization': 'true',
      'Authorization': token,
      'Accept': 'application/json',
    };

    final fileName = p.basename(file.path);

    // Multipart form data
    final form = FormData({
      // Backend dùng key `a` như contract API upload.
      'a': MultipartFile(file, filename: fileName),
    });

    final response = await post('/fileupload/upload', form, headers: headers);

    if (response.isOk) {
      final path = _extractUploadedPath(response.body);
      if (path != null) {
        return path;
      }
      throw Exception(
        'Tải file thành công nhưng máy chủ không trả về đường dẫn file.',
      );
    }

    throw Exception(response.statusText ?? 'Không thể tải lên file: $fileName');
  }

  String? _extractUploadedPath(dynamic value) {
    if (value is String) {
      final normalized = value.trim();
      return normalized.isEmpty ? null : normalized;
    }

    if (value is List) {
      for (final item in value) {
        final path = _extractUploadedPath(item);
        if (path != null) return path;
      }
      return null;
    }

    if (value is Map) {
      const preferredKeys = [
        'data',
        'Data',
        'filePath',
        'FilePath',
        'path',
        'Path',
        'url',
        'Url',
      ];
      for (final key in preferredKeys) {
        if (!value.containsKey(key)) continue;
        final path = _extractUploadedPath(value[key]);
        if (path != null) return path;
      }
    }

    return null;
  }
}
