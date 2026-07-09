import '../../core/network/api_client.dart';
import '../models/digital_map_models.dart';
import '../models/office_models.dart';

class DigitalMapService extends ApiClient {
  DigitalMapService() {
    onInit();
  }

  Future<VillagePage> getVillages({int page = 1, int limit = 500}) async {
    final body = await _getBody(
      '/village/get-list',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return VillagePage.fromJson(body);
  }

  Future<OfficePage> getActiveOffices({
    String key = '',
    int typeOfficeId = 0,
    int page = 1,
    int limit = 500,
  }) async {
    final body = await _getBody(
      '/office/get-list',
      query: {
        'key': key,
        'typeOfficeID': typeOfficeId.toString(),
        'statusID': '1',
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    return OfficePage.fromJson(body);
  }

  Future<TypeOfficePage> getTypeOffices({int page = 1, int limit = 500}) async {
    final body = await _getBody(
      '/type-office/get-list',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return TypeOfficePage.fromJson(body);
  }

  Future<WardPage> getActiveWards({int page = 1, int limit = 500}) async {
    final body = await _getBody(
      '/ward/get-list-active',
      query: {'page': page.toString(), 'limit': limit.toString()},
    );
    return WardPage.fromJson(body);
  }

  Future<Map<String, dynamic>> _getBody(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    final response = await get(endpoint, query: query);
    if (response.isOk && response.body is Map) {
      return Map<String, dynamic>.from(response.body as Map);
    }
    throw Exception(response.statusText ?? 'Không thể tải dữ liệu bản đồ số');
  }
}
