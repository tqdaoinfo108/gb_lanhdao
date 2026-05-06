import 'package:get/get.dart';
import '../controllers/digital_map_controller.dart';

/// Binding cho màn hình Bản đồ số.
class DigitalMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DigitalMapController>(() => DigitalMapController());
  }
}
