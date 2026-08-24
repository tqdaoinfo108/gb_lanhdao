import '../models/residence_models.dart';
import '../services/residence_service.dart';

class ResidenceRepository {
  final ResidenceService _service;

  ResidenceRepository({ResidenceService? service})
    : _service = service ?? ResidenceService();

  Future<ResidenceBundle> getBundle({
    String key = '',
    int villageId = 0,
    int typeHouseHoldId = 0,
    int statusId = -100,
  }) async {
    final results = await Future.wait<dynamic>([
      _service.getVillages(),
      _service.getHouseholds(
        key: key,
        villageId: villageId,
        typeHouseHoldId: typeHouseHoldId,
        statusId: statusId,
      ),
      _service.getHouseholdTypes(),
    ]);

    return ResidenceBundle(
      villages: results[0] as ResidenceVillagePage,
      households: results[1] as HouseholdPage,
      types: results[2] as HouseholdTypePage,
    );
  }

  Future<RegisterHouseHoldPage> getRegisterHouseHolds({
    int villageId = 0,
    int houseHoldId = 0,
    int statusId = -100,
    int typeRegisterId = 0,
  }) => _service.getRegisterHouseHolds(
    villageId: villageId,
    houseHoldId: houseHoldId,
    statusId: statusId,
    typeRegisterId: typeRegisterId,
  );

  Future<void> createRegisterHouseHold({
    required int houseHoldId,
    required int typeRegisterId,
    required String fullName,
    required String description,
  }) => _service.createRegisterHouseHold(
    houseHoldId: houseHoldId,
    typeRegisterId: typeRegisterId,
    fullName: fullName,
    description: description,
  );

  Future<void> updateRegisterHouseHold({
    required int registerHouseHoldId,
    required int typeRegisterId,
    required String fullName,
    required String description,
  }) => _service.updateRegisterHouseHold(
    registerHouseHoldId: registerHouseHoldId,
    typeRegisterId: typeRegisterId,
    fullName: fullName,
    description: description,
  );

  Future<void> deleteRegisterHouseHold(int registerHouseHoldId) =>
      _service.deleteRegisterHouseHold(registerHouseHoldId);
}
