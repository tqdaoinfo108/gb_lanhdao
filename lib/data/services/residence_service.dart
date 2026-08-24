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

  Future<RegisterHouseHoldPage> getRegisterHouseHolds({
    int villageId = 0,
    int houseHoldId = 0,
    int statusId = -100,
    int typeRegisterId = 0,
    int page = 1,
    int limit = 20,
  }) async {
    final body = await _getBody(
      '/register-house-hold/get-list',
      query: {
        'villageID': villageId.toString(),
        'houseHoldID': houseHoldId.toString(),
        'statusID': statusId.toString(),
        'typeRegisterID': typeRegisterId.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    return RegisterHouseHoldPage.fromJson(body);
  }

  Future<void> createRegisterHouseHold({
    required int houseHoldId,
    required int typeRegisterId,
    required String fullName,
    required String description,
  }) => _postMutation('/register-house-hold/create', {
    'HouseHoldID': houseHoldId,
    'TypeRegisterID': typeRegisterId,
    'FullName': fullName,
    'Description': description,
  });

  Future<void> updateRegisterHouseHold({
    required int registerHouseHoldId,
    required int typeRegisterId,
    required String fullName,
    required String description,
  }) => _postMutation('/register-house-hold/update', {
    'RegisterHouseHoldID': registerHouseHoldId,
    'TypeRegisterID': typeRegisterId,
    'FullName': fullName,
    'Description': description,
  });

  Future<void> deleteRegisterHouseHold(int registerHouseHoldId) =>
      _postMutation(
        '/register-house-hold/delete',
        const {},
        query: {'registerHouseHoldID': registerHouseHoldId.toString()},
      );

  Future<void> _postMutation(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, dynamic>? query,
  }) async {
    final response = await post(endpoint, body, query: query);
    if (!response.isOk) {
      throw Exception(
        response.statusText ?? 'Không thể cập nhật biến động dân cư',
      );
    }
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
