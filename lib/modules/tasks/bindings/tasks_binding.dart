import 'package:get/get.dart';
import 'package:gb_lanhdao/modules/tasks/controllers/tasks_controller.dart';

class TasksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TasksController>(() => TasksController());
  }
}


