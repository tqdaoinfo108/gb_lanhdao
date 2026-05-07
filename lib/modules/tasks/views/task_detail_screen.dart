import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gb_lanhdao/data/models/task_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:gb_lanhdao/modules/tasks/controllers/task_detail_controller.dart';
import 'package:gb_lanhdao/modules/tasks/views/widgets/add_subtask_dialog.dart';
import 'package:gb_lanhdao/modules/tasks/views/widgets/add_button.dart';
import 'package:gb_lanhdao/modules/tasks/views/widgets/subtask_card_widget.dart';

class TaskDetailScreen extends GetView<TaskDetailController> {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskDetailController>(
      builder: (_) {
        final task = controller.task;

        if (task == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chi tiết nhiệm vụ')),
            body: const Center(child: Text('Không tìm thấy thông tin nhiệm vụ')),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FD),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF6B7280)),
              onPressed: () => Get.back(),
            ),
            title: Text(
              task.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F1724),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(task),
                  const SizedBox(height: 12),
                  _buildSubTaskList(task),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(Task task) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskHeader(task),
          const SizedBox(height: 12),
          if (task.lateSubTasks > 0) _buildLateWarning(task),
          _buildProgressRow(task),
          const SizedBox(height: 12),
          _buildFooterRow(task),
        ],
      ),
    );
  }

  Widget _buildTaskHeader(Task task) {
    return Row(
      children: [
        const Icon(Icons.list_alt, size: 20, color: Color(0xFF2F6CE1)),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Danh sách nhiệm vụ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${task.doneSubTasks}/${task.subTasks.length}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ),
        const SizedBox(width: 8),
        AddButton(parentTaskTitle: task.title),
      ],
    );
  }

  Widget _buildLateWarning(Task task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '${task.lateSubTasks} nhiệm vụ trễ hạn',
          style: const TextStyle(fontSize: 13, color: Color(0xFFEF4444), fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildProgressRow(Task task) {
    return Row(
      children: [
        const Text(
          'Tiến độ',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LinearPercentIndicator(
            lineHeight: 8,
            percent: task.displayProgress.clamp(0.0, 1.0),
            backgroundColor: const Color(0xFFF3F4F6),
            progressColor: task.progressColor,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            barRadius: const Radius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '${(task.displayProgress * 100).round()}%',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: task.progressColor),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterRow(Task task) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            '${task.doneSubTasks}/${task.subTasks.length} hoàn thành',
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (task.kpiTotal != null)
          Flexible(
            child: Text(
              'KPI: ${task.kpiCurrent}/${task.kpiTotal} ${task.kpiUnit ?? ""}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2F6CE1)),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildSubTaskList(Task task) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: task.subTasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final subTask = task.subTasks[index];
        return SubTaskCard(
          subTask: subTask,
          onStatusChanged: (status) => controller.updateSubTaskStatus(subTask, status),
          onDelete: () => controller.deleteSubTask(subTask),
        );
      },
    );
  }
}