import 'package:get/get.dart';
import 'package:gb_lanhdao/data/models/task_model.dart';

import 'package:gb_lanhdao/modules/tasks/controllers/tasks_controller.dart';

class TaskDetailController extends GetxController {
  Task? task;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Task) {
      task = Get.arguments as Task;
    }
  }

  void updateSubTaskStatus(SubTask subTask, SubTaskStatus newStatus) {
    if (task == null) return;

    subTask.status = newStatus;

    // Cập nhật giao diện chi tiết
    update();

    // Đồng bộ và làm mới danh sách ở màn hình ngoài
    if (Get.isRegistered<TasksController>()) {
      Get.find<TasksController>().tasks.refresh();
    }
  }

  void addSubTask(SubTask subTask) {
    if (task == null) return;

    // Thêm vào list subtasks hiện tại
    task!.subTasks.add(subTask);

    // Cập nhật giao diện chi tiết
    update();

    // Đồng bộ và làm mới danh sách ở màn hình ngoài
    if (Get.isRegistered<TasksController>()) {
      Get.find<TasksController>().tasks.refresh();
    }
  }
}
