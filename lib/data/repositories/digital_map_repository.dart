import '../models/digital_map_models.dart';
import '../models/office_models.dart';
import '../services/digital_map_service.dart';

class DigitalMapRepository {
  final DigitalMapService _service;

  DigitalMapRepository({DigitalMapService? service})
    : _service = service ?? DigitalMapService();

  Future<DigitalMapBundle> getBundle({
    String key = '',
    int typeOfficeId = 0,
  }) async {
    final results = await Future.wait<dynamic>([
      _service.getVillages(),
      _service.getActiveOffices(key: key, typeOfficeId: typeOfficeId),
      _service.getTypeOffices(),
      _service.getActiveWards(),
    ]);

    return DigitalMapBundle(
      villages: results[0] as VillagePage,
      offices: results[1] as OfficePage,
      officeTypes: results[2] as TypeOfficePage,
      wards: results[3] as WardPage,
    );
  }
}
