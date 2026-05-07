import 'package:get/get.dart';
import 'package:gb_lanhdao/data/models/task_model.dart';
import 'package:gb_lanhdao/data/mock/tasks_mock_data.dart';

class TasksController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Task> tasks = <Task>[].obs;
  final RxString search = ''.obs;
  final RxString selectedTabType = 'Tất cả'.obs;

  final List<String> tabTypes = [
    'Tất cả',
    'Đúng tiến độ',
    'Có rủi ro',
    'Hoàn thành',
    'Chậm tiến độ',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMock();
  }

  void fetchMock() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    tasks.assignAll(tasksMockData);
    isLoading.value = false;
  }

  List<Task> get filteredTasks {
    List<Task> result = tasks;

    if (selectedTabType.value != 'Tất cả') {
      result = result.where((t) {
        final status = t.statusLabel.toLowerCase();
        final selected = selectedTabType.value.toLowerCase();

        if (selected == 'chậm tiến độ') {
          return status.contains('chậm tiến độ');
        } else if (selected == 'hoàn thành') {
          return status.contains('hoàn thành');
        } else if (selected == 'đúng tiến độ') {
          return status.contains('đúng tiến độ');
        } else if (selected == 'có rủi ro') {
          return status.contains('có rủi ro');
        }
        return false;
      }).toList();
    }

    if (search.value.trim().isEmpty) return result;
    final q = search.value.trim().toLowerCase();
    return result.where((t) {
      return t.title.toLowerCase().contains(q) ||
          t.department.toLowerCase().contains(q) ||
          t.owner.toLowerCase().contains(q) ||
          t.id.toLowerCase().contains(q);
    }).toList();
  }

  void setSearch(String value) => search.value = value;
  void setSelectedTab(String type) => selectedTabType.value = type;

  void addTask(Task task) {
    tasks.insert(0, task);
  }

  String getTabLabel(String type) {
    int count = 0;
    if (type == 'Tất cả') {
      count = tasks.length;
    } else {
      count = tasks.where((t) {
        final status = t.statusLabel.toLowerCase();
        final target = type.toLowerCase();
        return status.contains(target);
      }).length;
    }
    return '$type ($count)';
  }
}
