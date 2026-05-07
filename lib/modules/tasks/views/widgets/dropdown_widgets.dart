import 'package:flutter/material.dart';
import 'package:gb_lanhdao/data/models/task_model.dart';

class FormDropdown extends StatelessWidget {
  final String? value;
  final String? hint;
  final List<String> items;
  final Function(String?) onChanged;

  const FormDropdown({
    super.key,
    this.value,
    this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: hint != null ? Text(hint!, style: TextStyle(color: Colors.grey[400], fontSize: 15)) : null,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937))),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class PriorityDropdown extends StatelessWidget {
  final SubTaskPriority value;
  final Function(SubTaskPriority) onChanged;

  const PriorityDropdown({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SubTaskPriority>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
          items: SubTaskPriority.values.map((priority) {
            Color color;
            switch (priority) {
              case SubTaskPriority.cao:
                color = const Color(0xFFEF4444);
              case SubTaskPriority.trungBinh:
                color = const Color(0xFFF59E0B);
              case SubTaskPriority.thap:
                color = const Color(0xFF3B82F6);
            }
            return DropdownMenuItem(
              value: priority,
              child: Row(
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(priority.label, style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937))),
                ],
              ),
            );
          }).toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }
}

class StatusDropdown extends StatelessWidget {
  final SubTaskStatus value;
  final Function(SubTaskStatus) onChanged;

  const StatusDropdown({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final statusList = [SubTaskStatus.chuaLam, SubTaskStatus.dangLam, SubTaskStatus.hoanThanh];
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SubTaskStatus>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
          items: statusList.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status.label, style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937))),
            );
          }).toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }
}