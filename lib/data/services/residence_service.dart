import '../../core/network/api_client.dart';
import '../models/residence_models.dart';

class ResidenceService extends ApiClient {
  ResidenceService() {
    onInit();
  }

  Future<ResidenceVillagePage> getVillages({
    String key = '',
    int statusId = 1,
    int page = 1,
    int limit = 1000,
  }) async {
    final body = await _getBody(
      '/village/get-list',
      query: {
        'key': key,
        'statusID': statusId.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    return ResidenceVillagePage.fromJson(body);
  }

  Future<HouseholdPage> getHouseholds({
    String key = '',
    int villageId = 0,
    int typeHouseHoldId = 0,
    int statusId = -100,
    int page = 1,
    int limit = 1000,
  }) async {
    final body = await _getBody(
      '/house-hold/get-list',
      query: {
        'key': key,
        'VillageID': villageId.toString(),
        'typeHouseHoldID': typeHouseHoldId.toString(),
        'statusID': statusId.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    return HouseholdPage.fromJson(body);
  }

  Future<HouseholdTypePage> getHouseholdTypes({
    int statusId = 1,
    int page = 1,
    int limit = 1000,
  }) async {
    final body = await _getBody(
      '/type-house-hold/get-list',
      query: {
        'statusID': statusId.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    return HouseholdTypePage.fromJson(body);
  }

  Future<Map<String, dynamic>> _getBody(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    final response = await get(endpoint, query: query);
    if (response.isOk && response.body is Map) {
      return Map<String, dynamic>.from(response.body as Map);
    }
    throw Exception(
      response.statusText ?? 'Không thể tải dữ liệu dân cư và hộ gia đình',
    );
  }
}
