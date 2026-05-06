import 'package:get/get.dart';
import '../controllers/home_controller.dart';

/// Binding cho màn hình Home.
/// GetX sẽ tự động inject HomeController khi navigate đến HomeScreen.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
