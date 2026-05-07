import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:gb_lanhdao/data/models/task_model.dart';
import 'package:gb_lanhdao/modules/tasks/controllers/task_detail_controller.dart';
import 'package:gb_lanhdao/modules/tasks/views/widgets/form_widgets.dart';
import 'package:gb_lanhdao/modules/tasks/views/widgets/dropdown_widgets.dart';
import 'package:gb_lanhdao/modules/tasks/views/widgets/dropdown_widgets.dart';

class AddSubTaskDialog extends StatefulWidget {
  final String parentTaskTitle;
  const AddSubTaskDialog({super.key, required this.parentTaskTitle});

  @override
  State<AddSubTaskDialog> createState() => _AddSubTaskDialogState();
}

class _AddSubTaskDialogState extends State<AddSubTaskDialog> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final assigneeController = TextEditingController();
  final dateController = TextEditingController();

  DateTime? selectedDate;
  SubTaskPriority selectedPriority = SubTaskPriority.trungBinh;
  SubTaskStatus selectedStatus = SubTaskStatus.chuaLam;

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (selectedDate == null) {
        Get.snackbar('Thông báo', 'Vui lòng chọn hạn chót',
          backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }

      final newSubTask = SubTask(
        id: 'ST${DateTime.now().millisecondsSinceEpoch}',
        title: titleController.text,
        assignee: assigneeController.text,
        dueDate: selectedDate!,
        status: selectedStatus,
        priority: selectedPriority,
        isLate: selectedDate!.isBefore(DateTime.now()) && selectedStatus != SubTaskStatus.hoanThanh,
      );

      if (Get.isRegistered<TaskDetailController>()) {
        Get.find<TaskDetailController>().addSubTask(newSubTask);
      }

      Navigator.of(context).pop();
      Get.snackbar('Thành công', 'Đã thêm nhiệm vụ mới',
        backgroundColor: Colors.green, colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const Divider(height: 1),
            Flexible(child: _buildBody()),
            const Divider(height: 1),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thêm nhiệm vụ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                ),
                Text(
                  widget.parentTaskTitle,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormLabel('Tên nhiệm vụ', required: true),
            FormTextField(
              controller: titleController,
              hint: 'VD: Rà soát danh sách hộ nghèo',
              validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
            ),
            const SizedBox(height: 16),
            const FormLabel('Người phụ trách', required: true),
            FormTextField(
              controller: assigneeController,
              hint: 'VD: Nguyễn Văn A',
              validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDateField()),
                const SizedBox(width: 12),
                Expanded(child: _buildPriorityField()),
              ],
            ),
            const SizedBox(height: 16),
            const FormLabel('Trạng thái'),
            _buildStatusField(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormLabel('Hạn chót', required: true),
        FormDatePicker(
          controller: dateController,
          selectedDate: selectedDate,
          onDateSelected: (date) {
            setState(() {
              selectedDate = date;
              dateController.text = DateFormat('MM/dd/yyyy').format(date);
            });
          },
        ),
      ],
    );
  }

  Widget _buildPriorityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormLabel('Ưu tiên'),
        PriorityDropdown(
          value: selectedPriority,
          onChanged: (v) => setState(() => selectedPriority = v),
        ),
      ],
    );
  }

  Widget _buildStatusField() {
    return StatusDropdown(
      value: selectedStatus,
      onChanged: (v) => setState(() => selectedStatus = v),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              fixedSize: const Size(120, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            child: const Text('Hủy', style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _handleSave,
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(140, 44),
              backgroundColor: const Color(0xFF2F6CE1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Thêm nhiệm vụ', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
