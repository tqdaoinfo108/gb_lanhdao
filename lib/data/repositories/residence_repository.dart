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
}
