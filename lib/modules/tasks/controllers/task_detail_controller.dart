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

    _syncTaskChanges();
  }

  void addSubTask(SubTask subTask) {
    if (task == null) return;

    // Thêm vào list subtasks hiện tại
    task!.subTasks.add(subTask);

    _syncTaskChanges();
  }

  void deleteSubTask(SubTask subTask) {
    if (task == null) return;

    task!.subTasks.removeWhere((item) => item.id == subTask.id);

    _syncTaskChanges();
  }

  void _syncTaskChanges() {
    update();

    if (Get.isRegistered<TasksController>()) {
      Get.find<TasksController>().tasks.refresh();
    }
  }
}
