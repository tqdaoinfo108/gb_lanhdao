import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:gb_lanhdao/data/models/task_model.dart';
import 'package:gb_lanhdao/modules/tasks/controllers/tasks_controller.dart';
import 'package:gb_lanhdao/modules/tasks/views/widgets/form_widgets.dart';
import 'package:gb_lanhdao/modules/tasks/views/widgets/dropdown_widgets.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final ownerController = TextEditingController();
  final targetController = TextEditingController(text: '100');
  final actualController = TextEditingController(text: '0');
  final unitController = TextEditingController();
  final dateController = TextEditingController();

  String? selectedCategory;
  String? selectedDepartment;
  String selectedStatus = 'Đúng tiến độ';
  DateTime? selectedDate;

  final categories = ['Xã hội', 'Hành chính', 'Số hóa', 'Hạ tầng', 'Y tế', 'Kinh tế', 'Nông nghiệp', 'An ninh', 'Giáo dục', 'Môi trường', 'Khác'];
  final departments = ['VP UBND', 'Tư pháp', 'Địa chính', 'Kỹ thuật', 'Y tế', 'Kinh tế', 'Nông nghiệp', 'Công an', 'Giáo dục', 'Văn hóa', 'Tài chính'];
  final statuses = ['Đúng tiến độ', 'Chậm tiến độ', 'Có rủi ro', 'Hoàn thành'];

  void _handleSave() {
    if (_formKey.currentState!.validate() && _validateForm()) {
      final newTask = Task(
        id: 'T${DateTime.now().millisecondsSinceEpoch}',
        title: titleController.text,
        department: selectedDepartment!,
        owner: ownerController.text,
        progress: (double.tryParse(actualController.text) ?? 0) / (double.tryParse(targetController.text) ?? 100),
        date: selectedDate!,
        statusLabel: selectedStatus,
        avatarUrls: ['https://i.pravatar.cc/150?u=1', 'https://i.pravatar.cc/150?u=2', 'https://i.pravatar.cc/150?u=3'],
        subTasks: [],
        kpiCurrent: int.tryParse(actualController.text),
        kpiTotal: int.tryParse(targetController.text),
        kpiUnit: unitController.text,
      );
      if (Get.isRegistered<TasksController>()) Get.find<TasksController>().addTask(newTask);
      Navigator.of(context).pop();
      Get.snackbar('Thành công', 'Đã thêm KPI mới', backgroundColor: Colors.green, colorText: Colors.white);
    }
  }

  bool _validateForm() {
    if (selectedDate == null) {
      Get.snackbar('Thông báo', 'Vui lòng chọn hạn chót', backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }
    if (selectedCategory == null || selectedDepartment == null) {
      Get.snackbar('Thông báo', 'Vui lòng chọn danh mục và phòng ban', backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: Get.height * 0.9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(), const Divider(height: 1), Flexible(child: _buildForm()), _buildFooter()],
      ),
    ),
  );

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
    child: Row(
      children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFEAF1FF), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.track_changes, color: Color(0xFF2F6CE1), size: 24)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Thêm KPI mới', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
          Text('Điền đầy đủ thông tin chương trình & chỉ tiêu', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ])),
        IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close, color: Color(0xFF9CA3AF))),
      ],
    ),
  );

  Widget _buildForm() => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Form(key: _formKey, child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormLabel('Tên chương trình / KPI', required: true),
        FormTextField(controller: titleController, hint: 'VD: Giảm nghèo bền vững 2026', validator: (v) => v!.isEmpty ? 'Không được để trống' : null),
        const SizedBox(height: 16),
        Row(children: [Expanded(child: _buildCategoryField()), const SizedBox(width: 12), Expanded(child: _buildDepartmentField())]),
        const SizedBox(height: 16),
        const FormLabel('Người phụ trách', required: true),
        FormTextField(controller: ownerController, hint: 'VD: Nguyễn Văn A', validator: (v) => v!.isEmpty ? 'Không được để trống' : null),
        const SizedBox(height: 16),
        Row(children: [Expanded(child: _buildTargetField()), const SizedBox(width: 12), Expanded(child: _buildActualField()), const SizedBox(width: 12), Expanded(child: _buildUnitField())]),
        const SizedBox(height: 16),
        Row(children: [Expanded(child: _buildDateField()), const SizedBox(width: 12), Expanded(child: _buildStatusField())]),
      ],
    )),
  );

  Widget _buildCategoryField() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const FormLabel('Danh mục', required: true), FormDropdown(value: selectedCategory, hint: 'Chọn danh mục', items: categories, onChanged: (v) => setState(() => selectedCategory = v))]);
  Widget _buildDepartmentField() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const FormLabel('Phòng ban', required: true), FormDropdown(value: selectedDepartment, hint: 'Chọn phòng ban', items: departments, onChanged: (v) => setState(() => selectedDepartment = v))]);
  Widget _buildTargetField() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const FormLabel('Chỉ tiêu', required: true), FormTextField(controller: targetController, hint: '100', keyboardType: TextInputType.number, validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Phải > 0' : null)]);
  Widget _buildActualField() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const FormLabel('Thực tế'), FormTextField(controller: actualController, hint: '0', keyboardType: TextInputType.number)]);
  Widget _buildUnitField() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const FormLabel('Đơn vị đo', required: true), FormTextField(controller: unitController, hint: 'hộ, %, người...', validator: (v) => v!.isEmpty ? 'Trống' : null)]);
  Widget _buildDateField() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const FormLabel('Hạn chót', required: true), FormDatePicker(controller: dateController, selectedDate: selectedDate, onDateSelected: (date) => setState(() { selectedDate = date; dateController.text = DateFormat('MM/dd/yyyy').format(date); }))]);
  Widget _buildStatusField() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const FormLabel('Trạng thái'), FormDropdown(value: selectedStatus, items: statuses, onChanged: (v) => setState(() => selectedStatus = v!))]);

  Widget _buildFooter() => Padding(
    padding: const EdgeInsets.all(20),
    child: Row(children: [
      Expanded(child: OutlinedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), side: const BorderSide(color: Color(0xFFE5E7EB))),
        child: const Text('Hủy bỏ', style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.w600)),
      )),
      const SizedBox(width: 12),
      Expanded(child: ElevatedButton(
        onPressed: _handleSave,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2F6CE1), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add, size: 18), SizedBox(width: 4), Text('Thêm KPI', style: TextStyle(fontWeight: FontWeight.w600))]),
      )),
    ]),
  );
}